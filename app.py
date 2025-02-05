from flask import Flask, render_template, request, redirect
import psycopg2
from argon2 import PasswordHasher
from dotenv import load_dotenv
from os import getenv

load_dotenv()

app = Flask(__name__)

# This is super stupid
# we late initialize the password hash
password_hasher = None
# this ONLY works because there is absolutely zero asynchronous code in here.
# otherwise we'd get multiple password hashers. I don't think it would be a real
# problem but it sure would be a waste

def hash(password):
    global password_hasher
    if password_hasher == None:
        password_hasher = PasswordHasher()

    return password_hasher.hash(password)

def verify(passhash):
    global password_hasher
    if password_hasher == None:
        password_hasher = PasswordHasher()
    
    return password_hasher.verify(passhash)

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname=getenv('DB_NAME'),
    user=getenv('DB_USER'),         
    password=getenv('DB_PASSWD'),
    host=getenv('DB_HOST'),
    port=getenv('DB_PORT')
)

@app.route('/')
def index():
    return render_template('signup.html')

@app.route('/signup', methods=['POST'])
def signup():
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    student_id = request.form['student_id']
    university = request.form['university']
    course = request.form['course']
    username = request.form['username']
    password = request.form['password']

    try:
        cur = conn.cursor()
        # Insert data into the table
        cur.execute("""
            INSERT INTO students (first_name, last_name, student_id, university, course, username, password)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (first_name, last_name, student_id, university, course, username, hash(password)))
        conn.commit()
        cur.close()
        return redirect('/show_entries')
    except Exception as e:
        return f"Error: {e}"

@app.route('/show_entries')
def show_entries():
    cur = conn.cursor()  
    cur.execute("SELECT * FROM students")
    rows = cur.fetchall()
    cur.close()
    return render_template('entries.html', rows=rows)

def main():
    app.run(debug=True)

if __name__ == '__main__':
    main()
