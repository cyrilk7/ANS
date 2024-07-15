# app/models.py
from app import db, bcrypt
import uuid

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
