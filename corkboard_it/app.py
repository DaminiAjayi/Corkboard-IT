from flask import Flask, render_template, flash, redirect, url_for, session,\
logging, request
from flask_mysqldb import MySQL
from wtforms import Form, StringField, TextAreaField, PasswordField, validators,\
SelectField
from passlib.hash import sha256_crypt
from functools import wraps

from forms import SearchPushpinForm, AddCorkboardForm, UserLoginForm, PrivateLoginForm


# Place holder for current module
app = Flask(__name__)

# Configure MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'jdemeo'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'cs6400'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor' # Changes the way results are returned from MySQL (default=tuple)

# Initialize MySQL
mysql = MySQL(app)

"""ROUTES"""

# Initial Login
@app.route('/login', methods=["GET","POST"])
def login():

    form = UserLoginForm(request.form)

    if request.method == "POST" and form.validate():

        cur = mysql.connection.cursor()

        # Get form data
        email = form.email.data
        pin_candidate = form.pin.data

        result = cur.execute("SELECT * FROM User WHERE email = %s", [email])

        if result > 0:
            data = cur.fetchone()
            pin = data['pin']

            # Successful Login
            if pin_candidate == pin:
                # Store current users email
                session['email'] = email
                print(session['email'])
                return redirect(url_for('index'))
            # Failed pin
            else:
                flash('Pin is incorrect', 'danger')
                return render_template(
                    'login.html',
                    form=form)

        # Failed Email
        else:
            flash('No user exists with that email', 'danger')
            return render_template(
                'login.html',
                form=form)

    return render_template(
        'login.html',
        form=form)

# View Home Screen
@app.route('/', methods=['GET', 'POST'])
def index():

    # Search PushPins will call Search PushPins task (search_results)
    search = SearchPushpinForm(request.form)

    if request.method == 'POST':
        return search_results(search)

    cur = mysql.connection.cursor()

    # Display User's Name
    cur.execute("SELECT CONCAT(fname, ' ', lname) AS full_name, email\
        FROM `User`\
        WHERE email = %s", [session['email']])
    current_user = cur.fetchone()

    # Display most recently updated Corkboards
    cur.execute("SELECT user_cork_push.corkboardID, user_cork_push.full_name, user_cork_push.title, user_cork_push.recent_date, user_cork_push.type\
        FROM (SELECT CONCAT(`User`.fname, ' ', `User`.lname) AS full_name, User.email,\
        pub.corkboardID, pub.title, MAX(pin.pushpin_date) AS recent_date, 'public' AS type\
        FROM `User`\
        INNER JOIN PublicCorkboard AS pub\
        ON pub.owner_email = `User`.email\
        INNER JOIN Pushpin AS pin\
        ON pin.owner_email = pub.owner_email\
        AND pin.corkboardID = pub.corkboardID\
        GROUP BY full_name, `User`.email,\
        pub.corkboardID, pub.title, type\
        UNION ALL\
        SELECT CONCAT(`User`.fname, ' ', `User`.lname) AS full_name, User.email,\
        prv.corkboardID, prv.title, MAX(pin.pushpin_date) AS recent_date, 'private' as type\
        FROM `User`\
        INNER JOIN PrivateCorkboard AS prv\
        ON prv.owner_email = `User`.email\
        INNER JOIN Pushpin AS pin\
        ON pin.owner_email = prv.owner_email\
        AND pin.corkboardID = prv.corkboardID\
        GROUP BY full_name, `User`.email,\
        prv.corkboardID, prv.title, type) AS user_cork_push\
        WHERE user_cork_push.email IN (\
        SELECT Follows.followee_email FROM Follows\
        INNER JOIN `User` ON `User`.email = Follows.Followee_email\
        WHERE Follows.follower_email = %s)\
        OR (user_cork_push.email, user_cork_push.corkboardID) IN (\
        SELECT `User`.email, Corkboard.corkboardID FROM Watches\
        INNER JOIN Corkboard ON Corkboard.corkboardID = Watches.corkboardID\
        INNER JOIN `User` ON `User`.email = Corkboard.owner_email\
        WHERE Watches.watcher_email = %s)\
        OR user_cork_push.email = %s\
        ORDER BY user_cork_push.recent_date DESC\
        LIMIT 4", [session['email'] for _ in range(3)])
    recent_updates = cur.fetchall()

    # Display User's Corkboards
    cur.execute("SELECT title, 'private' AS type, corkboardID,\
        (SELECT COUNT(*) FROM Pushpin\
        WHERE owner_email = prv.owner_email\
        AND corkboardID = prv.corkboardID) AS pushpin_count\
        FROM PrivateCorkboard as prv\
        WHERE prv.owner_email = %s\
        UNION ALL\
        SELECT title, 'public', corkboardID,\
        (SELECT COUNT(*) FROM Pushpin\
        WHERE owner_email = pub.owner_email\
        AND corkboardID = pub.corkboardID) AS pushpin_count\
        FROM PublicCorkboard as pub\
        WHERE pub.owner_email = %s\
        ORDER BY title", [session['email'] for _ in range(2)])
    my_corkboards = cur.fetchall()

    cur.close()

    return render_template(
        'home.html',
        current_user=current_user,
        recent_updates=recent_updates,
        my_corkboards=my_corkboards,
        form=search)

# View Search PushPin Results  JUST PLACE HOLDER CODE
@app.route('/search_results')
def search_results(search):

    results = []
    search_string = search.search.data

    return render_template(
        'search_results.html',
        search_string=search_string)

# Private Corkboard Login
@app.route('/private_login/<string:id>/',methods=["GET","POST"])
def private_login(id):

    form = PrivateLoginForm(request.form)

    if request.method == "POST" and form.validate():

        cur = mysql.connection.cursor()

        # Get form data
        password_candidate = form.password.data

        # Get PrivateCorkboard password
        result = cur.execute("SELECT password FROM PrivateCorkboard\
            WHERE corkboardID = %s", [id])
        password = cur.fetchone()['password']

        # Successful Login
        if password_candidate == password:
            # Store current users email
            return redirect(url_for('index'))

        # Failed password
        else:
            flash('Password is incorrect', 'danger')
            return render_template(
                'private_login.html',
                form=form)

    return render_template(
        'private_login.html',
        form=form)

# Add Corkboard
@app.route('/add_corkboard', methods=['GET', 'POST'])
def add_corkboard():

    form = AddCorkboardForm(request.form)

    # Need to read database for categories
    cur = mysql.connection.cursor()
    result = cur.execute("SELECT category FROM Category")
    categories = cur.fetchall()
    for category in categories:
        # Add each category to form attribute category for drop down list
        form.category.choices.append((category['category'], category['category']))

    cur.close()

    # Form is submitted and valid inputs
    if request.method == 'POST' and form.validate():

        cur = mysql.connection.cursor()

        # Get form data
        email = session['email']
        title = form.title.data
        category = form.category.data
        visibility = form.visibility.data
        password = form.password.data

        if visibility == 'private' and password == '':
            cur.close()
            flash('Please provide password!', 'danger')
            return redirect(url_for('add_corkboard'))

        # Create supertype Corkboard
        cur.execute("INSERT INTO Corkboard(owner_email)\
            VALUES (%s)", [email])
        mysql.connection.commit()

        # Get corkboardID from most recently generated Corkboard
        cur.execute("SELECT corkboardID FROM Corkboard\
            WHERE owner_email = %s\
            ORDER BY corkboardID DESC\
            LIMIT 1", [email])
        corkboardID = cur.fetchall()[0]['corkboardID']

        # Private Corkboard Add
        if visibility == 'private':
            print('Added Private Corkboard')
            print('EMAIL:', email)
            print('TITLE:', title)
            print('CATEGORY:', category)
            print('VISIBILITY', visibility)
            print('PASSWORD:', password)

            cur.execute("INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)\
                VALUES (%s, %s, %s, %s, %s)",
                [corkboardID, email, title, category, password])
            mysql.connection.commit()

            cur.close()

            return redirect(url_for('index'))

        # Public Corkboard Add
        else:
            print('Added Public Corkboard')
            print('EMAIL:', email)
            print('TITLE:', title)
            print('CATEGORY:', category)
            print('VISIBILITY', visibility)

            cur.execute("INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)\
                VALUES (%s, %s, %s, %s)",
                [corkboardID, email, title, category])
            mysql.connection.commit()

            cur.close()

            return redirect(url_for('index'))

    return render_template(
        'add_corkboard.html',
        form=form)

# Check if this is the script to be executed
if __name__ == '__main__':
    app.secret_key='secret123'
    # Start/run application
    # @debug: True allows for saving file and reloading routes without
    # restarting connection
    app.run(debug=True)
