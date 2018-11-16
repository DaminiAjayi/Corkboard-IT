from flask import Flask, render_template, flash, redirect, url_for, session,\
logging, request
from flask_mysqldb import MySQL
from wtforms import Form, StringField, TextAreaField, PasswordField, validators,\
SelectField
from functools import wraps

from forms import SearchPushpinForm, AddCorkboardForm, UserLoginForm, PrivateLoginForm


# Place holder for current module
app = Flask(__name__)

# Configure MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'jdemeo'
app.config['MYSQL_PASSWORD'] = 'pigasus1234'
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
    search_text = search.search.data

    if request.method == 'POST':
        # return search_results(search)
        return redirect(url_for('search_results', search_text=search_text))

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
# @app.route('/search_results')
# def search_results(search):
#
#     results = []
#     search_string = search.search.data
#
#     return render_template(
#         'search_results.html',
#         search_string=search_string)


# View search pushpins task
@app.route('/search_results/<search_text>')
def search_results(search_text):

    cur = mysql.connection.cursor()

    search_text = '%' + search_text + '%'

    cur.execute("SELECT DISTINCT pin.pushpinID, description AS PushPinDescription, category AS CorkBoard, CONCAT(fname, ' ', lname) AS fullname\
                FROM `User`\
                INNER JOIN PublicCorkboard AS pub ON pub.owner_email = `User`.email\
                INNER JOIN Pushpin AS pin ON pin.corkboardID = pub.corkboardID\
                LEFT JOIN Tags ON Tags.pushpinID = pin.pushpinID\
                WHERE description LIKE %s OR\
                tag LIKE %s OR\
                category LIKE %s\
                ORDER BY description DESC", [search_text, search_text, search_text])
    # print(cur.fetchall())

    results = cur.fetchall()

    return render_template('search_results.html', results=results)

# View Popular Sites
@app.route('/popular_sites',methods=["GET","POST"])
def popular_sites():

    cur = mysql.connection.cursor()
    result = cur.execute("SELECT DISTINCT SUBSTRING(\
      url,\
      LOCATE('//', url) + 2,\
      LOCATE('/', url, LOCATE('//', url) + 2) - LOCATE('//', url) - 2\
    ) AS PopularSite,\
    COUNT(*) AS CountPopularSite\
    FROM Pushpin\
    GROUP BY PopularSite\
    ORDER BY CountPopularSite DESC")

    # Do not need to check for result if a result exist no matter what
    sites = cur.fetchall()
    cur.close()

    return render_template(
        "popular_sites.html",
        sites=sites)

# View Corkboard Stats Task
@app.route('/CorkboardStats')
def CorkboardStatsView():


    cur = mysql.connection.cursor()

    rows = cur.execute("SELECT CONCAT(fname, ' ', lname) AS Name, (SELECT COUNT(*) FROM PublicCorkboard WHERE owner_email = c.email) AS pub_cork_count, (SELECT COUNT(*) FROM PrivateCorkboard WHERE owner_email = c.email) AS prv_cork_count, (SELECT COUNT(*) FROM PublicCorkboard NATURAL JOIN Pushpin WHERE owner_email = c.email) AS pub_push_count,(SELECT COUNT(*) FROM PrivateCorkboard NATURAL JOIN Pushpin WHERE owner_email = c.email) AS prv_push_count FROM User AS c GROUP BY email ORDER BY pub_cork_count DESC, prv_cork_count DESC")

    data = cur.fetchall()

    print(data[0])

    cur.execute("SELECT CONCAT(fname, ' ', lname) AS Name FROM `User` WHERE email = %s", [session['email']])

    current_user = cur.fetchone()
    print(current_user)

    return render_template('ViewCorkboardStats.html', result = data, current = current_user)

# View popular tags task
@app.route('/PopularTags')
def TagStatsView():

	cur = mysql.connection.cursor()

	rows = cur.execute("SELECT tag, COUNT(tag) AS PushPins, COUNT(DISTINCT corkboardID) AS Corkboards FROM TAGS NATURAL JOIN (SELECT pushpinID, corkboardID FROM PUSHPIN) AS a GROUP BY tag ORDER BY PushPins DESC, Corkboards DESC");

	data = cur.fetchall()

	print(data)

	return render_template('PopularTags.html', result = data)


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
            return redirect(url_for('ViewCorkboard', id=id))

        # Failed password
        else:
            flash('Password is incorrect', 'danger')
            return render_template(
                'private_login.html',
                form=form)

    return render_template(
        'private_login.html',
        form=form)

# VIEW CORKBOARD TASK
@app.route('/corkboard/<string:id>/', methods=["POST","GET"])
def ViewCorkboard(id):
    cur = mysql.connection.cursor()
    # Display owners Name
    cur.execute("SELECT CONCAT(fname, ' ', lname) AS full_name, email\
                FROM `User`, `Corkboard`\
                WHERE corkboardID = %s AND `User`.email = `Corkboard`.owner_email", [id])
    owner = cur.fetchone()

    # Display owner's Category
    cur.execute("SELECT category, title FROM PublicCorkboard\
        UNION SELECT category, title FROM PrivateCorkboard\
                WHERE corkboardID = %s", [id])
    category = cur.fetchone()

    # #Last Updated Date
    cur.execute("SELECT pushpin_date FROM Pushpin\
                 WHERE corkboardID = %s\
                 ORDER BY pushpin_date DESC", [id])
    date_updated = cur.fetchone()

    # #Number of watchers
    cur.execute("SELECT Count(*) AS Count FROM Watches\
                WHERE corkboardID = %s", [id])
    num_watchers = cur.fetchone()

    #Image thumbnails
    cur.execute("SELECT url, pushpinID FROM Pushpin\
                WHERE corkboardID = %s", [id])
    images = cur.fetchall()

    check_follower=cur.execute("SELECT * FROM Follows WHERE follower_email=%s AND followee_email=%s",[session['email'],owner['email']])
    # enable_FOllow=0 means current user is the owner of corkboard, follow button should be disabled
    enable_Follow=0
    if check_follower==0 and session['email']!= owner['email']:
        # user has not followed the page and current user is not the owner of corkboard, you can follow the user
        enable_Follow=1
    elif check_follower>0 and session['email']!= owner['email']:
        # user followed the page and current user is not the owner of corkboard, you can unfollow the user
        enable_Follow=2

    check_watcher=cur.execute("SELECT * FROM Watches WHERE watcher_email = %s AND corkboardID = %s", [session['email'], id])
    # enable_watch=0 means current user is the owner of corkboard, watch button should be disabled
    enable_Watch=0
    if check_watcher==0 and session['email']!= owner['email']:
        # user has not watched the page and current user is not the owner of corkboard, you can watch the corkboard page
        enable_Watch=1
    elif check_watcher>0 and session['email']!= owner['email']:
        # user watched the page and current user is not the owner of corkboard, you can unwatch the corkboard page
        enable_Watch=2
    if session['email']== owner['email']:
        # enable_addpushpin=1 means current user is the owner of corkboard, add pushpin button should be activated
        enable_addpushpin=1
    else:
        # enable_addpushpin=0 means current user is not the owner of corkboard, add pushpin button should be disabled
        enable_addpushpin=0

    if request.method=="POST":
        if 'Follow' in request.form:
            Follow_op=request.form['Follow']
            if Follow_op=="unFollow":
                result=cur.execute("DELETE FROM Follows WHERE  follower_email= %s AND followee_email = %s", [session['email'],owner['email']])
                mysql.connection.commit()
                return redirect(url_for('ViewCorkboard',id=id))
            elif Follow_op=="Follow":
                result=cur.execute("INSERT INTO Follows (follower_email, followee_email) VALUES (%s, %s)",  [session['email'],owner['email']])
                mysql.connection.commit()
                return redirect(url_for('ViewCorkboard',id=id))
        if 'Watch' in request.form:
            Watch_op=request.form['Watch']
            if Watch_op=="unWatch":
                result=cur.execute("DELETE FROM Watches WHERE  watcher_email= %s AND corkboardID = %s", [session['email'], id])
                mysql.connection.commit()
                return redirect(url_for('ViewCorkboard',id=id))
            elif Watch_op=="Watch":
                result=cur.execute("INSERT INTO Watches(watcher_email, corkboardID) VALUES (%s, %s)",[session['email'], id])
                mysql.connection.commit()
                return redirect(url_for('ViewCorkboard',id=id))
        if 'Addpushpin'in request.form:
            return redirect(url_for('AddPushpinView', id=id))


    return render_template('view_corkboard.html', owner=owner,
                            session=session['email'], category=category,
                            date_updated=date_updated, num_watchers=num_watchers,images=images, enable_Follow=enable_Follow,enable_Watch=enable_Watch,enable_addpushpin=enable_addpushpin)


def Watch(id):
    check_watch = cur.execute("SELECT * FROM Watches\
                                WHERE email = %s\
                                 AND corkboardID = %s", [session['email'], id])

    #Check to see if user is already watching corkboard
    if check_watch > 0:
        #IF watching, stop watching
        cur.execute("DELETE FROM Watches(watcher_email, corkboardID)\
         WHERE watcher_email = %s AND corkBoardID = %s",[session['email'], id])

        cur.commit()


    else:
        #If not watching, start watching
        cur.execute("INSERT INTO Watches(watcher_email, corkboardID) VALUES (%s, %s)",[session['email'], id])
        cur.commit()

    return redirect(url_for('ViewCorkboard'))
#
#
def Follow(followee_email, id):
    check_follower = cur.execute("SELECT * FROM Follows\
                                    WHERE follower_email = %s\
                                    AND corkboardID = %s", [session['email'], id])

    #Check to see if user is already following corkboard
    if check_follower > 0:
        #If following, stop following
        cur.execute("DELETE FROM Follows(follower_email, followee_email)\
         WHERE follower_email = %s AND followee_email = %s", [session['email'], followee_email])
        cur.commit()
    else:
        #If not following, start following
        cur.execute("INSERT INTO Follows(follower_email, followee_email)\
                    VALUES (%s, %s)", [session['email'], followee_email])
        cur.commit()
    return redirect(url_for('ViewCorkboard'))


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

# Add PushPin task
@app.route('/AddPushpin/<id>/', methods=['POST','GET'])
def AddPushpinView(id):

    if request.method == 'POST':

        URL = str(request.form['URL'])
        if len(URL) > 500 and len(URL) < 1:
            flash('URL length is invalid', 'danger')
            return render_template(
                'AddPushpin.html')

        Description = str(request.form['Description'])
        if len(Description) > 199 and len(Description) < 1:
            flash('Description length is invalid', 'danger')
            return render_template(
                'AddPushpin.html')

        Tags = str(request.form['Tags']).lower()
        Tags = Tags.split(',')
        Tags = [Tag.strip() for Tag in Tags if Tag != '']

        for tag in Tags:
            if len(tag) > 20:
                flash('Tags must be 20 characters or less', 'danger')
                return render_template(
                    'AddPushpin.html')

        cur = mysql.connection.cursor()

        corkboardID_current = id
        print(corkboardID_current)
        owner_current = session['email']

        cur.execute("INSERT INTO Pushpin(corkboardID, owner_email, url, description) VALUES (%s,%s,%s,%s);", (corkboardID_current,owner_current,URL,Description))

        mysql.connection.commit()

        pushpinID_current = cur.execute("SELECT pushpinID FROM Pushpin ORDER BY pushpinID DESC LIMIT 1;")
        pushpinID_current = cur.fetchall()[0]['pushpinID']
        print(pushpinID_current, type(pushpinID_current))

        for Tag in Tags:
            if Tag != '':
                cur.execute("INSERT INTO Tags(tag, pushpinID) VALUE (%s,%s);", (Tag,pushpinID_current))

                mysql.connection.commit()

        return redirect(url_for('ViewCorkboard',id=id))

    print(id)
    return render_template('AddPushpin.html')



# View Pushpin Task
@app.route('/pushpin/<pushpinID>',methods=["GET","POST"])
def pushpin(pushpinID):
    cur=mysql.connection.cursor()
    result=cur.execute("SELECT fname, lname, owner_email FROM Pushpin INNER JOIN `User`ON Pushpin.owner_email=`User`.email WHERE pushpinID =%s",[pushpinID])
    if result>0:
        data=cur.fetchone()
        fname=data['fname']
        lname=data['lname']
        owner_email=data['owner_email']

    result=cur.execute("SELECT title FROM Pushpin NATURAL JOIN PrivateCorkboard WHERE pushpinID=%s\
        UNION SELECT title FROM Pushpin NATURAL JOIN PublicCorkboard WHERE pushpinID=%s",[pushpinID, pushpinID])
    if result>0:
        data=cur.fetchone()
        title=data['title']

    result=cur.execute("SELECT corkboardID, url, SUBSTRING(\
        url,\
        LOCATE('//', url) + 2,\
        LOCATE('/', url, LOCATE('//', url) + 2) - LOCATE('//', url) - 2) AS domain,\
        description, pushpin_date FROM Pushpin WHERE pushpinID=%s",[pushpinID])
    if result>0:
        data=cur.fetchone()
        corkboardID=data['corkboardID']
        url=data['url']
        url_domain=data['domain']
        description=data['description']
        pushpin_date=data['pushpin_date']

    result= cur.execute("SELECT tag FROM Pushpin LEFT OUTER JOIN Tags ON Pushpin.pushpinID = Tags.pushpinID WHERE Pushpin.pushpinID=%s",[pushpinID])
    taglist=[]
    if result>0:
        data=cur.fetchall()
        for itag in range(len(data)):
            taglist.append(data[itag]['tag'])

    result = cur.execute("SELECT CONCAT(fname, ' ', lname) AS fullname FROM (Pushpin LEFT OUTER JOIN Likes ON Pushpin.pushpinID = Likes.pushpinID) \
        LEFT OUTER JOIN `User` ON liker_email = email WHERE Pushpin.pushpinID=%s",[pushpinID])
    likerlist=[]
    if result>0:
        data=cur.fetchall()
        print(data)
        for iliker in range(len(data)):
            # WHY THIS IF STATEMENT?
            if data[iliker] != None:
                likerlist.append(data[iliker]['fullname'])

    result = cur.execute("SELECT CONCAT(fname, ' ', lname) AS fullname, comment, comment_date FROM Pushpin NATURAL JOIN `Comment` \
        LEFT OUTER JOIN `User` ON Comment.commenter_email = `User`.email \
        WHERE Pushpin.pushpinID = %s ORDER BY comment_date DESC",[pushpinID])
    commentlist=[]
    if result>0:
        data=cur.fetchall()
        print(data)
        for icom in range(len(data)):
            commentlist.append([data[icom]['fullname'],data[icom]['comment']])

    result = cur.execute("SELECT * FROM Likes WHERE pushpinID = %s AND liker_email = %s", [pushpinID,session['email']])
    enable_Like=0
    # user has not liked the pushpin and current user is not owner of pushpin, you can like the pushpin
    if result ==0 and session['email']!=owner_email:
        enable_Like=1
    # user liked the pushpin and current user is not owner of pushpin, you can unlike the pushpin
    elif result>0 and session['email']!=owner_email:
        enable_Like=2

    result=cur.execute("SELECT * FROM Follows WHERE follower_email=%s AND followee_email=%s",[session['email'],owner_email])
    # enable_Follow=0 means current user is the owner of pushpin, follow button should be disabled
    enable_Follow=0
    if result==0 and session['email']!=owner_email:
        # user has not followed the page and current user is not the owner of pushpin, you can follow the user
        enable_Follow=1
    elif result>0 and session['email']!=owner_email:
        # user followed the page and current user is not the owner of pushpin, you can unfollow the user
        enable_Follow=2


    if request.method=="POST":
        if 'Like' in request.form:
            Like_op=request.form['Like']
            if Like_op=="unLike":
                result=cur.execute("DELETE FROM Likes WHERE pushpinID = %s AND liker_email = %s", [pushpinID,session['email']])
                mysql.connection.commit()
                return redirect(url_for('pushpin',pushpinID=pushpinID))
            elif Like_op=="Like":
                result=cur.execute("INSERT INTO Likes (pushpinID, liker_email) VALUES (%s, %s)", [pushpinID,session['email']])
                mysql.connection.commit()
                return redirect(url_for('pushpin',pushpinID=pushpinID))

        if 'Follow' in request.form:
            Follow_op=request.form['Follow']
            if Follow_op=="unFollow":
                result=cur.execute("DELETE FROM Follows WHERE  follower_email= %s AND followee_email = %s", [session['email'],owner_email])
                mysql.connection.commit()
                return redirect(url_for('pushpin',pushpinID=pushpinID))
            elif Follow_op=="Follow":
                result=cur.execute("INSERT INTO Follows (follower_email, followee_email) VALUES (%s, %s)",  [session['email'],owner_email])
                mysql.connection.commit()
                return redirect(url_for('pushpin',pushpinID=pushpinID))

        elif 'Coms' in request.form:
            Coms=request.form['Coms']
            result=cur.execute("INSERT INTO `Comment`(commenter_email, pushpinID, comment) VALUES(%s, %s, %s)",[session['email'],pushpinID,Coms])
            mysql.connection.commit()
            return redirect(url_for('pushpin',pushpinID=pushpinID))

    return render_template("pushpin.html",fname=fname,lname=lname,title=title,corkboardID=corkboardID,pushpin_date=pushpin_date,url_domain=url_domain,\
    url=url,description=description,taglist=taglist,likerlist=likerlist,commentlist=commentlist,enable_Like=enable_Like, enable_Follow=enable_Follow)





# Check if this is the script to be executed
if __name__ == '__main__':
    app.secret_key='secret123'
    # Start/run application
    # @debug: True allows for saving file and reloading routes without
    # restarting connection
    app.run(debug=True)
