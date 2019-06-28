from flask import Flask, render_template, request, json, jsonify
from flaskext.mysql import MySQL
from pymongo import MongoClient
from werkzeug import generate_password_hash, check_password_hash
from datetime import datetime
import logging
from crud import sql_select, sql_delete, sql_update, sql_insert
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

@app.route('/showLogin')
def showLogin():
    app.logger.info('In showLogin API, rendering login.html')
    return render_template('login.html')

@app.route('/showCustomerAccountDisplay')
def showCustomerAccountDisplay():
    app.logger.info('In showCustomerAccountDisplay API, rendering customerAccountDisplay.html')
    return render_template('customerAccountDisplay.html')

@app.route('/showMachines')
def showMachines():
    app.logger.info('In showMachines API, rendering machines.html')
    return render_template('machines.html')

@app.route('/showOrderHistory')
def showOrderHistory():
    app.logger.info('In showOrderHistory API, rendering orderHistory.html')
    return render_template('orderHistory.html')

@app.route('/showBilling')
def showBilling():
    app.logger.info('In showBilling API, rendering billing.html')
    return render_template('billing.html')

@app.route('/showProfile')
def showProfile():
    app.logger.info('In showProfile API, rendering profile.html')
    return render_template('profile.html')

@app.route('/showHelp')
def showHelp():
    app.logger.info('In showHelp API, rendering help.html')
    return render_template('help.html')

@app.route('/showCsp')
def showCsp():
    app.logger.info('In showCsp API, rendering csp.html')
    return render_template('csp.html')

@app.route('/showCspMachines')
def showCspMachines():
    app.logger.info('In showCspMachines API, rendering cspMachines.html')
    return render_template('cspMachines.html')

@app.route('/showCspOrderHistory')
def showCspOrderHistory():
    app.logger.info('In showCspOrderHistory API, rendering cspOrderHistory.html')
    return render_template('cspOrderHistory.html')

@app.route('/showCspProfile')
def showCspProfile():
    app.logger.info('In showCspProfile API, rendering cspProfile.html')
    return render_template('cspProfile.html')

@app.route('/showCspHelp')
def showCspHelp():
    app.logger.info('In showCspHelp API, rendering cspHelp.html')
    return render_template('cspHelp.html')

@app.route('/showCspBilling')
def showCspBilling():
    app.logger.info('In showCspBilling API, rendering cspBilling.html')
    return render_template('cspBilling.html')

@app.route('/showAdmin')
def showAdmin():
    app.logger.info('In showAdmin API, rendering admin.html')
    return render_template('admin.html')


if __name__ == '__main__':
    handler = RotatingFileHandler('app.log', maxBytes=10000, backupCount=1)
    app.logger.addHandler(handler)
    app.run(debug=True)
