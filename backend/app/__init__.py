from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_mail import Mail
from flask_cors import CORS
from config import Config
import os
import pymysql

app = Flask(__name__)
app.config.from_object(Config)

# Initialize database connection using environment variables
hostname = os.getenv('HOSTNAME')
user = 'root'
password = os.getenv('PASSWORD')

db = pymysql.connect(
    host=hostname,
    user=user,
    password=password
)

cursor = db.cursor()
cursor.execute("CREATE DATABASE IF NOT EXISTS ANS_db")
cursor.close()
db.close()


db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
mail = Mail(app)
CORS(app)


from app import routes, models

with app.app_context():
    db.create_all()