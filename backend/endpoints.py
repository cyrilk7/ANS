import pymysql
from flask import Flask, request, jsonify, url_for, render_template_string, render_template, flash
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_mail import Mail, Message
import re
import uuid
from dotenv import load_dotenv
import os
from flask_cors import CORS
from flask_migrate import Migrate
from datetime import datetime, timedelta
from werkzeug.utils import secure_filename
from sqlalchemy.sql.expression import func
from sshtunnel import SSHTunnelForwarder
from firebase_admin import credentials, firestore, initialize_app, storage
from api_config import app, db, bucket, bcrypt, mail


class User(db.Model):
    __tablename__ = 'users'
    user_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(500), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(100), nullable=True)
    status = db.Column(db.Enum('Active', 'Inactive'), nullable=False, default='Inactive')
    role = db.Column(db.String(50), nullable=False, default='User')
    activation_token = db.Column(db.String(36), unique=True, nullable=True)

    def __init__(self, name, email, password=None, status='Inactive', role='User'):
        self.email = email
        self.name = name
        if password:
            self.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
        self.status = status
        self.role = role
        self.activation_token = str(uuid.uuid4())

    def check_password(self, password):
        return bcrypt.check_password_hash(self.password_hash, password)

class BuildingCategory(db.Model):
    __tablename__ = 'building_category'
    category_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    categoryImage = db.Column(db.String(300), nullable=False)

class Building(db.Model):
    __tablename__ = 'building'
    building_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(500))
    historical_information = db.Column(db.String(500))
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    image_path = db.Column(db.String(500))
    map_id = db.Column(db.String(500))
    category_id = db.Column(db.Integer, db.ForeignKey('building_category.category_id'))
    category = db.relationship('BuildingCategory', backref='buildings')

class RoomType(db.Model):
    __tablename__ = 'room_type'
    type_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

class Room(db.Model):
    __tablename__ = 'room'
    room_id = db.Column(db.Integer, primary_key=True)
    building_id = db.Column(db.Integer, db.ForeignKey('building.building_id'))
    type_id = db.Column(db.Integer, db.ForeignKey('room_type.type_id'))
    room_number = db.Column(db.String(20))
    room_name = db.Column(db.String(200))
    capacity = db.Column(db.Integer)
    building = db.relationship('Building', backref='rooms')
    room_type = db.relationship('RoomType', backref='rooms')

class Event(db.Model):
    __tablename__ = 'event'
    event_id = db.Column(db.Integer, primary_key=True)
    registrar = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    room_id = db.Column(db.Integer, db.ForeignKey('room.room_id'))
    building_id = db.Column(db.Integer, db.ForeignKey('building.building_id'))
    name = db.Column(db.String(100), nullable=False)
    organizer = db.Column(db.String(100), nullable=False)
    date_booked = db.Column(db.DateTime)
    event_date = db.Column(db.Date)
    event_time = db.Column(db.Time)
    duration = db.Column(db.Integer)
    room = db.relationship('Room', backref='events')
    building = db.relationship('Building', backref='buildings')
    user = db.relationship('User', backref='users')


with app.app_context():
    db.create_all()

ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'svg'])

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Define route to serve images
@app.route('/images/<path:filename>')
def get_image(filename):
    static_dir = os.path.join(os.path.dirname(__file__), 'static', 'images', 'building_uploads')
    return send_from_directory(static_dir, filename)

@app.route('/activate/<token>', methods=['GET'])
def activate_user(token):
    user = User.query.filter_by(activation_token=token).first()
    

    if not user:
        return jsonify({'message': 'Invalid or expired token'}), 400

    return render_template('set_password.html', token=token)



@app.route('/users', methods=['POST'])
def create_user():
    data = request.get_json()
    
    # Check if email and password fields are provided
    if not data or 'email' not in data:
        return jsonify({'message': 'Email is required'}), 400
    
    # Check if email and password fields are provided
    if not data or 'name' not in data:
        return jsonify({'message': 'Name is required'}), 400

    email = data.get('email')
    role = data.get('role', 'User')
    name = data.get('name')

    # Validate email format
    email_regex = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    if not re.match(email_regex, email):
        return jsonify({'message': 'Invalid email format'}), 400

    # Check if a user with the given email already exists
    if User.query.filter_by(email=email).first():
        return jsonify({'message': 'User with this email already exists'}), 400

    # If the user does not exist, create a new user
    user = User(email=email, name=name, role=role)
    db.session.add(user)
    db.session.commit()

    mail_html = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Verify Your Email</title>
        <style>
            .email-container {
                max-width: 600px;
                margin: auto;
                padding: 20px;
                font-family: Arial, sans-serif;
                border: 1px solid #ddd;
                border-radius: 10px;
            }
            .email-header {
                text-align: center;
                margin-bottom: 20px;
            }
            .email-logo {
                max-width: 100px;
            }
            .email-body {
                text-align: center;
            }

            .email-body h2{
                color: #AA3B3E;
            }
            
            .email-footer {
                text-align: center;
                margin-top: 20px;
                color: #888;
                font-size: 12px;
            }
            .activation-button {
                background-color: #AA3B3E;
                color: white;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="email-container">
            <div class="email-header">
                <img src="{{url_for('static', filename="logo.png")}}" alt="Logo" class="email-logo">
            </div>
            <div class="email-body">
                <h2>Verify Your Email</h2>
                <p>Thank you for registering. Please click the button below to verify your email address and activate your account:</p>
                <a href="{{ activation_url }}" class="activation-button">Activate Your Account</a>
                <p>This link will expire in 24 hours.</p>
            </div>
            <div class="email-footer">
                <p>If you didn't request this, you can safely ignore this email.</p>
            </div>
        </div>
    </body>
    </html>
    '''


    token = user.activation_token
    activation_url = url_for('activate_user', token=token, _external=True)
    msg = Message('Account Activation', sender='ashesinavigationsystem@gmail.com', recipients=[email])
    msg.html = render_template_string(mail_html, activation_url=activation_url)
    mail.send(msg)

    return jsonify({'message': 'User created successfully. Please check email to activate account.'}), 201



@app.route('/set-password', methods=['POST'])
def set_password():
    token = request.form['token']
    password = request.form['password']
    confirm_password = request.form['confirm_password']

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

    user = User.query.filter_by(activation_token=token).first()
    if user:
        user.password_hash = hashed_password
        # user.activation_token = None  # Clear the token after use
        user.status = 'Active'
        db.session.commit()
        return render_template('password_successful.html')
        
    else:
        #To-do
        return jsonify({"message": "Invalid or expired token"})




@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()


    if not data or 'email' not in data or 'password' not in data:
        return jsonify({'message': 'Email and password are required'}), 400

    email = data.get('email')
    password = data.get('password')

    # Check if the user exists
    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({'message': 'Invalid email'}), 401

    # Check if the user is active
    if user.status != 'Active':
        return jsonify({'message': 'User account is not active'}), 403

    # Verify the password
    if not user.check_password(password):
        return jsonify({'message': 'Invalid password'}), 401

    
    return jsonify({'message': 'Login successful',  'token' : user.activation_token}), 200


@app.route('/buildings', methods=['GET'])
def get_buildings():
    buildings = Building.query.all()
    results = []

    for building in buildings:
        building_info = {
            'building_id': building.building_id,
            'name': building.name,
            'description': building.description,
            'category_id': building.category.category_id,
            'category': building.category.name,
            'categoryImage': building.category.categoryImage,
            'history': building.historical_information,
            'latitude': building.latitude,
            'longitude': building.longitude,
            'image_path': f"{building.image_path}",
            'map_id': building.map_id if building.map_id else '',
            'rooms': [
                {
                    'room_id': room.room_id,
                    'room_number': room.room_number,
                    'room_name': room.room_name,
                    'type': room.room_type.name,
                    'building': room.building.name,
                    'capacity': room.capacity
                }
                for room in building.rooms
            ]
        }
        results.append(building_info)

    return jsonify(results)


@app.route('/categories', methods=['GET'])
def get_categories():
    categories = BuildingCategory.query.all()
    results = []

    for category in categories:
        category_info = {
            'category_id': category.category_id,
            'name': category.name
        }
        results.append(category_info)

    return jsonify(results), 200


# @app.route('/buildings', methods=['POST'])
def create_building():

    # Check if the post request has the file part
    if 'files[]' not in request.files:
        resp = jsonify({'message': 'No file part in the request'})
        resp.status_code = 400
        return resp
    
    files = request.files.getlist('files[]')
    errors = {}
    success = False

    for file in files:
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            success = True
        else:
            errors[file.filename] = 'File type is not allowed'
    
    if success and errors:
        errors['message'] = 'File(s) successfully uploaded'
        resp = jsonify(errors)
        resp.status_code = 500
        return resp
    elif success:
        resp = jsonify({'message': 'Files successfully uploaded'})
        resp.status_code = 201
        return resp
    else:
        resp = jsonify(errors)
        resp.status_code = 500
        return resp

    data = request.get_json()

    # Check if all required fields are provided
    required_fields = ['name', 'description', 'category_id', 'latitude', 'longitude']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'Missing required field: {field}'}), 400
    
    name = data['name']
    latitude = data['latitude']
    longitude = data['longitude']

        # Check if a building with the same name exists
    if Building.query.filter_by(name=name).first():
        return jsonify({'error': 'Building with the same name already exists'}), 403

    # Check if a building with the same latitude and longitude exists
    if Building.query.filter_by(latitude=latitude, longitude=longitude).first():
        return jsonify({'error': 'Building with the same coordinates already exists'}), 403


    # Create a new building instance
    new_building = Building(
        name=name,
        description=data.get('description'),
        historical_information=data.get('history'),
        latitude=latitude,
        longitude=longitude,
        image_path=data.get('image_path'),
        category_id=data.get('category_id')
    )

    # Add and commit the new building to the database
    db.session.add(new_building)
    db.session.commit()

    return jsonify({'message': 'Building created successfully'}), 201

# @app.route('/buildings', methods=['POST'])
# def create_building_with_image():
#     # Check if all required fields and file part are provided
#     if 'name' not in request.form or 'description' not in request.form or 'category_id' not in request.form \
#             or 'latitude' not in request.form or 'longitude' not in request.form or 'file' not in request.files:
#         return jsonify({'error': 'Missing required fields or file part in the request'}), 400

#     # Extract building data
#     building_name = request.form['name']
#     description = request.form['description']
#     history = request.form['history']
#     category_id = int(request.form['category_id'])
#     latitude = float(request.form['latitude'])
#     longitude = float(request.form['longitude'])

#     # Check if a building with the same name exists
#     if Building.query.filter_by(name=building_name).first():
#         return jsonify({'error': 'Building with the same name already exists'}), 403

#     # Check if a building with the same latitude and longitude exists
#     if Building.query.filter_by(latitude=latitude, longitude=longitude).first():
#         return jsonify({'error': 'Building with the same coordinates already exists'}), 403

#     # Handle file upload
#     file = request.files['file']
#     if file and allowed_file(file.filename):
#         # Generate a unique filename to avoid overwriting existing files
#         filename = secure_filename(file.filename)
#         counter = 1
#         while os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], filename)):
#             name, extension = os.path.splitext(file.filename)
#             filename = f"{name}_{counter}{extension}"
#             counter += 1
        
#         file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
#         image_path = os.path.join('static/images/building_uploads', filename)
#     else:
#         return jsonify({'error': 'Invalid file or file type not allowed'}), 400

#     # Create a new building instance
#     new_building = Building(
#         name=building_name,
#         description=description,
#         latitude=latitude,
#         longitude=longitude,
#         image_path=image_path,
#         category_id=category_id,
#         historical_information=history,
#     )

#     # Add and commit the new building to the database
#     db.session.add(new_building)
#     db.session.commit()

#     return jsonify({'message': 'Building created successfully', 'building_id': new_building.building_id}), 201

@app.route('/buildings', methods=['POST'])
def create_building_with_image():
    # Check if all required fields and file part are provided
    if 'name' not in request.form or 'description' not in request.form or 'category_id' not in request.form \
            or 'latitude' not in request.form or 'longitude' not in request.form or 'file' not in request.files:
        return jsonify({'error': 'Missing required fields or file part in the request'}), 400

    # Extract building data
    building_name = request.form['name']
    description = request.form['description']
    history = request.form['history']
    category_id = int(request.form['category_id'])
    latitude = float(request.form['latitude'])
    longitude = float(request.form['longitude'])

    # Check if a building with the same name exists
    if Building.query.filter_by(name=building_name).first():
        return jsonify({'error': 'Building with the same name already exists'}), 403

    # Check if a building with the same latitude and longitude exists
    if Building.query.filter_by(latitude=latitude, longitude=longitude).first():
        return jsonify({'error': 'Building with the same coordinates already exists'}), 403

    # Handle file upload
    file = request.files['file']
    if file and allowed_file(file.filename):
        # Upload the image to Firebase Storage
        blob = bucket.blob(f'post_images/{file.filename}')
        blob.upload_from_file(file)

        # Make the file publicly accessible
        blob.make_public()
        image_path = blob.public_url
    else:
        return jsonify({'error': 'Invalid file or file type not allowed'}), 400

    # Create a new building instance
    new_building = Building(
        name=building_name,
        description=description,
        latitude=latitude,
        longitude=longitude,
        image_path=image_path,
        category_id=category_id,
        historical_information=history,
    )

    # Add and commit the new building to the database
    db.session.add(new_building)
    db.session.commit()

    return jsonify({'message': 'Building created successfully', 'building_id': new_building.building_id}), 201

@app.route('/buildings/<int:building_id>', methods=['GET'])
def get_building(building_id):
    building = Building.query.filter_by(building_id=building_id).first()
    if not building:
        return jsonify({'error': 'Building not found'}), 404
    
    building_data = {
        'building_id': building.building_id,
        'name': building.name,
        'description': building.description,
        'history': building.historical_information,
        'latitude': building.latitude,
        'longitude': building.longitude,
        'image_path': f"{building.image_path}",
        'category_id': building.category.category_id,
        'category': building.category.name if building.category else None,
        'map_id': building.map_id if building.map_id else '',
        'rooms': [
                {
                    'room_number': room.room_number,
                    'room_name': room.room_name,
                    'type': room.room_type.name,
                    'building': room.building.name,
                    'capacity': room.capacity
                }
                for room in building.rooms
            ]
    }
    
    return jsonify(building_data)

@app.route('/buildings/<int:building_id>', methods=['PUT'])
def edit_building(building_id):
    data = request.form

    building = Building.query.get(building_id)
    if not building:
        return jsonify({"error": "Building not found"}), 404

    if 'name' in data:
        building.name = data['name']
    if 'description' in data:
        building.description = data['description']
    if 'history' in data:
        building.historical_information = data['history']
    if 'latitude' in data:
        building.latitude = data['latitude']
    if 'longitude' in data:
        building.longitude = data['longitude']
    if 'category_id' in data:
        category = BuildingCategory.query.get(data['category_id'])
        if not category:
            return jsonify({"error": "Category not found"}), 404
        building.category_id = data['category_id']

    # Handle file upload
    if 'file' in request.files:
        file = request.files['file']
        if file and allowed_file(file.filename):
            # Generate a unique filename to avoid overwriting existing files
            filename = secure_filename(file.filename)
            counter = 1
            while os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], filename)):
                name, extension = os.path.splitext(file.filename)
                filename = f"{name}_{counter}{extension}"
                counter += 1
            
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            image_path = os.path.join('static/images/building_uploads', filename)
            building.image_path = image_path
        else:
            return jsonify({'error': 'Invalid file or file type not allowed'}), 400

    db.session.commit()

    return jsonify({"message": "Building updated successfully"}), 200

@app.route('/buildings/<int:building_id>', methods=['DELETE'])
def delete_building(building_id):
    building = Building.query.get(building_id)
    if not building:
        return jsonify({"error": "Building not found"}), 404

    db.session.delete(building)
    db.session.commit()

    return jsonify({"message": "Building deleted successfully"}), 200


@app.route('/statistics', methods=['GET'])
def get_stats():
    total_buildings = Building.query.count()
    total_users = User.query.count()
    total_events = Event.query.count()
    users = User.query.all()

    users_list = [{
        'user_id': user.user_id,
        'name': user.name,
        'email': user.email,
        'status': user.status,
        'role': user.role,
        'activation_token': user.activation_token
    } for user in users]

    return jsonify({
        'total_buildings': total_buildings,
        'total_users': total_users,
        'total_events': total_events,
        'users': users_list
    })

@app.route('/users/<int:user_id>', methods=['PUT'])
def edit_user(user_id):
    data = request.get_json()

    # Find the user by ID
    user = User.query.get(user_id)
    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Update user details
    if 'name' in data:
        user.name = data['name']
    if 'email' in data:
        user.email = data['email']
    if 'status' in data:
        if data['status'] in ['Active', 'Inactive']:
            user.status = data['status']
        else:
            return jsonify({'message': 'Invalid status value'}), 400
    if 'role' in data:
        user.role = data['role']
    if 'password' in data:
        # Hash the new password before storing it
        hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
        user.password_hash = hashed_password

    # Save changes to the database
    db.session.commit()

    return jsonify({'message': 'User updated successfully'}), 200

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    # Find the user by ID
    user = User.query.get(user_id)
    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Delete the user from the database
    db.session.delete(user)
    db.session.commit()

    return jsonify({'message': 'User deleted successfully'}), 200


@app.route('/events', methods=['GET'])
def get_all_events():
    events = db.session.query(Event).all()
    events_info = []

    for event in events:
        registrar = db.session.query(User).filter_by(user_id=event.registrar).first()
        room = db.session.query(Room).filter_by(room_id=event.room_id).first()
        building = db.session.query(Building).filter_by(building_id=event.building_id).first()

        space = building.name if not room else f"{room.room_number} - {building.name}"

        event_info = {
            "event_id": event.event_id,
            "building_id": event.building_id,
            "room_id": event.room_id if event.room_id else None,
            "registrar": registrar.name if registrar else None,
            "name": event.name,
            "space": space,
            "organizer": event.organizer,
            "event_date": event.event_date.strftime('%Y-%m-%d') if event.event_date else None,
            "event_time": event.event_time.strftime('%H:%M:%S') if event.event_time else None,
            "duration": event.duration
        }

        events_info.append(event_info)

    return jsonify(events_info)


from datetime import datetime

@app.route('/events', methods=['POST'])
def create_event():
    data = request.json
    
    name = data.get('name')
    organizer = data.get('organizer')
    registrar = data.get('registrar')
    building_id = data.get('building_id')
    room_id = data.get('room_id')
    event_date = datetime.strptime(data.get('event_date'), '%Y-%m-%d').date() if data.get('event_date') else None
    event_time = datetime.strptime(data.get('event_time'), '%H:%M').time() if data.get('event_time') else None
    duration = data.get('duration')

    # Set the date booked to the current date
    date_booked = datetime.now().date()

    # Create the event
    event = Event(
        name=name, 
        organizer=organizer, 
        registrar=registrar, 
        building_id=building_id, 
        room_id=room_id, 
        event_date=event_date, 
        event_time=event_time, 
        duration=duration,
        date_booked=date_booked  # Assigning the current date to date_booked
    )

    db.session.add(event)
    db.session.commit()

    return jsonify({'message': 'Event created successfully'}), 201




@app.route('/events/<day>', methods=['GET'])
def get_events_by_day(day):
    try:
        # Parse the date from the URL parameter in the format YYYY-MM-DD
        event_date = datetime.strptime(day, '%Y-%m-%d').date()
    except ValueError:
        return jsonify({"error": "Invalid date format. Use YYYY-MM-DD."}), 400

    # Query events for the given date
    events = db.session.query(Event).filter_by(event_date=event_date).all()

    # Group events by their start time
    grouped_events = {}
    for event in events:
        start_time = event.event_time.strftime('%I:%M %p')  # Format with AM/PM
        end_time = (datetime.combine(event.event_date, event.event_time) + timedelta(minutes=event.duration)).strftime('%I:%M %p')
        event_data = {
            "event_id": event.event_id,
            "start_time": start_time,
            "end_time": end_time,
            "title": event.name,
            "organizer": event.organizer,
            "date_booked": event.date_booked.strftime('%Y-%m-%d %H:%M:%S'),
            "event_date": event.event_date.strftime('%Y-%m-%d')
        }
        # Add building details
        if event.building:
            building_data = {
                "building_id": event.building.building_id,
                "name": event.building.name,
                "description": event.building.description,
                "history": event.building.historical_information,
                "latitude": event.building.latitude,
                "longitude": event.building.longitude,
                "image_path": event.building.image_path,
                "map_id": event.building.map_id,
                "category": event.building.category.name,
                "category_id": event.building.category_id,
            }
            event_data["building"] = building_data
        # Add room details if available
        if event.room:
            room_data = {
                "room_id": event.room.room_id,
                "building_id": event.room.building_id,
                "type_id": event.room.type_id,
                "room_number": event.room.room_number,
                "room_name": event.room.room_name,
                "capacity": event.room.capacity
            }
            event_data["room"] = room_data
        
        if start_time not in grouped_events:
            grouped_events[start_time] = []
        grouped_events[start_time].append(event_data)
        
    return jsonify(grouped_events)




@app.route('/random-buildings', methods=['GET'])
def get_random_buildings():
    buildings = Building.query.order_by(func.random()).limit(5).all()
    results = []

    for building in buildings:
        building_info = {
            'building_id': building.building_id,
            'name': building.name,
            'description': building.description,
            'category_id': building.category.category_id,
            'category': building.category.name,
            'categoryImage': building.category.categoryImage,
            'history': building.historical_information,
            'latitude': building.latitude,
            'longitude': building.longitude,
            'image_path': f"http://127.0.0.1:5000/{building.image_path}",
            'map_id': building.map_id if building.map_id else '',
            'rooms': [
                {
                    'room_id': room.room_id,
                    'room_number': room.room_number,
                    'room_name': room.room_name,
                    'type': room.room_type.name,
                    'building': room.building.name,
                    'capacity': room.capacity
                }
                for room in building.rooms
            ]
        }
        results.append(building_info)

    return jsonify(results)

@app.route('/upload-images', methods=['POST'])
def upload_images():
    if 'files' not in request.files:
        return jsonify({'error': 'No files part'}), 400

    files = request.files.getlist('files')
    if not files:
        return jsonify({'error': 'No files selected'}), 400

    public_urls = []
    for file in files:
        if file and allowed_file(file.filename):
            # Generate a unique filename
            filename = file.filename
            blob = bucket.blob(f'post_images/{filename}')
            
            # Upload the file to the bucket
            blob.upload_from_file(file)
            
            # Make the file publicly accessible
            blob.make_public()
            
            # Get the public URL
            image_url = blob.public_url
            public_urls.append(image_url)
        else:
            return jsonify({'error': f'File {file.filename} is not allowed'}), 400
    
    return jsonify({'public_urls': public_urls}), 200


if __name__ == "__main__":
    app.run(debug=True)