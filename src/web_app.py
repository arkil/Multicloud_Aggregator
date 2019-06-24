from flask import Flask, render_template, request, json, jsonify
from flaskext.mysql import MySQL
from pymongo import MongoClient
from werkzeug import generate_password_hash, check_password_hash
from datetime import datetime
import logging
from logging.handlers import RotatingFileHandler
from bson.objectid import ObjectId

app = Flask(__name__)
mysql = MySQL()


app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
app.config['MYSQL_DATABASE_DB'] = 'multicloud'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

# MongoDB configurations
client = MongoClient('mongodb://localhost:27017/')
mongodb = client['multicloud']

@app.route('/')
def main():
    app.logger.info('In main API, rendering index.html')
    return render_template('index.html')


if __name__ == '__main__':
    handler = RotatingFileHandler('app.log', maxBytes=10000, backupCount=1)
    app.logger.addHandler(handler)
    app.run(debug=True)
