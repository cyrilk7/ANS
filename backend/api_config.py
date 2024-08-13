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

load_dotenv()

# SSH configuration
ssh_host = os.getenv('SSH_HOST')
ssh_port = int(os.getenv('SSH_PORT'))
ssh_username = os.getenv('SSH_USERNAME')
ssh_password = os.getenv('SSH_PASSWORD')

# MySQL configuration
mysql_host = os.getenv('MYSQL_HOST')
mysql_port = int(os.getenv('MYSQL_PORT'))
mysql_user = os.getenv('MYSQL_USER')
mysql_password = os.getenv('MYSQL_PASSWORD')
mysql_db = os.getenv('MYSQL_DB')

# Start the SSH tunnel
server = SSHTunnelForwarder(
    (ssh_host, ssh_port),
    ssh_username=ssh_username,
    ssh_password=ssh_private_key_path,
    remote_bind_address=(mysql_host, mysql_port)
)

server.start()


app = Flask(__name__)
cred = credentials.Certificate('artlink-56f38-firebase-adminsdk-2th85-a12925cada.json')
default_app = initialize_app(cred, {
        'storageBucket': 'artlink-56f38.appspot.com'
})
bucket = storage.bucket()

app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql+pymysql://{mysql_user}:{mysql_password}@127.0.0.1:{server.local_bind_port}/{mysql_db}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# app.config.from_object(Config)

# Configuration from environment variables
app.config['DEBUG'] = os.getenv('DEBUG') == 'True'
app.config['TESTING'] = os.getenv('TESTING') == 'True'
app.config['MAIL_SERVER'] = os.getenv('MAIL_SERVER')
app.config['MAIL_PORT'] = int(os.getenv('MAIL_PORT'))
app.config['MAIL_USE_TLS'] = os.getenv('MAIL_USE_TLS') == 'True'
app.config['MAIL_USE_SSL'] = os.getenv('MAIL_USE_SSL') == 'True'
app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')
app.config['MAIL_DEFAULT_SENDER'] = os.getenv('MAIL_DEFAULT_SENDER')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = 'app/static/images/building_uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

CORS(app)



# Creating an instance of the SQLAlchemy class
db = SQLAlchemy(app)
migrate = Migrate(app, db)
bcrypt = Bcrypt(app)
mail = Mail(app)