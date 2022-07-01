import json
from flask import Flask, jsonify, render_template, abort
import psycopg2
import psycopg2.extras
import os
from flask_cors import CORS
from dotenv import load_dotenv

app = Flask(__name__)
load_dotenv()
CORS(app, origins=["http://localhost:8080"])

def get_connection():
    db = psycopg2.connect(database=os.environ.get("database"), user=os.environ.get("user"), password=os.environ.get("password"), options=os.environ.get("options"), host=os.environ.get("host"))
    db.autocommit = True
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    return db, cursor

def get_table_names():
    db, cursor = get_connection()
    cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = '{}'".format(os.environ.get("schema")))
    result = cursor.fetchall()
    return [dict(row).get("table_name") for row in result]

@app.route("/<recurso_nombre>", methods=["GET"])
def get(recurso_nombre):    
    if recurso_nombre not in get_table_names():
        abort(404)
    db, cursor = get_connection()
    cursor.execute("SELECT * FROM "  + recurso_nombre)
    result = cursor.fetchall()
    
    return jsonify({
        recurso_nombre : [dict(row) for row in result]
    }), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        "success" : False,
        "code" : 404
    }), 404

if __name__ == "__main__":
    app.run(debug=True)