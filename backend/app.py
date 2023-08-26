from flask import Flask, jsonify
from web3 import Web3
from flask_sqlalchemy import SQLAlchemy
import json
from flask_restful import Api, Resource
from flask_restful_swagger import swagger
from flask_swagger_ui import get_swaggerui_blueprint

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = ''
db = SQLAlchemy(app)

w3 = Web3(Web3.HTTPProvider(' '))

contract_address = ''
with open('abi.json') as f:
    contract_abi = json.load(f)

contract = w3.eth.contract(address=contract_address, abi=contract_abi)

class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    event_name = db.Column(db.String(255), nullable=False)
    event_data = db.Column(db.JSON, nullable=False)

with app.app_context():
    db.create_all()
    print('created')

def save_event_to_db(event_name, event_data):
    new_event = Event(event_name=event_name, event_data=event_data)
    db.session.add(new_event)
    db.session.commit()

def get_events_from_db(event_name):
    events = Event.query.filter_by(event_name=event_name).all()
    return events

class EventsResource(Resource):
    @swagger.operation(
        nickname='get'
    )
    def get(self):
        """List all events."""
        events = get_events_from_db('Event')
        event_list = [{'event_name': event.event_name, 'event_data': event.event_data} for event in events]
        return jsonify(event_list)

class SpecificEventsResource(Resource):
    @swagger.operation(
        nickname='get_specific'
    )
    def get(self, event_name):
        """List specific events."""
        events = get_events_from_db(event_name)
        event_list = [{'event_name': event.event_name, 'event_data': event.event_data} for event in events]
        return jsonify(event_list)

api = Api(app)
api = swagger.docs(Api(app), apiVersion='1.0')
api.add_resource(EventsResource, '/api/events')
api.add_resource(SpecificEventsResource, '/api/events/<string:event_name>')

SWAGGER_URL = '/swagger'
LOCAL_API_URL = 'http://127.0.0.1:5000/swagger.json'
PROD_URL = 'https://ctfapi.onrender.com/swagger.json'
swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    PROD_URL,
    config={
        'app_name': "Sample API"
    }
)
app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

@app.route('/swagger.json')
def swagger_json():
    with open('swagger.json', 'r') as f:
        return jsonify(json.load(f))

def event_listener():
    print('running')
    eventnames = ['ApproveCancel', 'Cancel', 'Deposit', 'OwnershipTransferred', 'Release']
    print(eventnames)
    for event_name in eventnames:
        print(event_name)
        event_filter = contract.events[event_name].create_filter(fromBlock='latest')
        print('true')
        new_entries = event_filter.get_new_entries()
        print(new_entries)
        for event in new_entries:
            save_event_to_db(event_name, event)
            print(f"Event '{event_name}' saved to database")

if __name__ == '__main__':
    event_listener()
    app.run(debug=True)
