import sqlite3
from flask import Flask

app = Flask(__name__)
app.config.from_pyfile("config.py")
# app.run(port = 5001)

my_db = 'stroke_apis//app.db'
conn = sqlite3.connect(my_db,check_same_thread=False)

from stroke_apis.routes import *
