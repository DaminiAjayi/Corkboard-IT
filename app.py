from flask import Flask, render_template, request, url_for, redirect
from flask_mysqldb import MySQL
from wtforms import Form, StringField, TextAreaField, PasswordField, validators
from passlib.hash import sha256_crypt
from forms import LoginForm

app = Flask(__name__)

#Config MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'corkboardit'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

#Init MySQL
mysql = MySQL(app)





# Login Task
@app.route('/')
def load():
	return render_template('login.html')

@app.route('/', methods = ['POST', 'GET'])

def login():

	if request.method == 'POST':
		UserEmail = request.form['email']
		PIN = int(request.form['PIN'])

		# print(UserEmail)
		# print(PIN)
		# print(type(PIN))
		cur = mysql.connection.cursor()

		rows = cur.execute("SELECT * FROM User WHERE email = %s",[UserEmail]);
		# print(rows)
		result = cur.fetchall()
		# print(result)

		try:
			if UserEmail == result[0]['email'] and PIN == result[0]['pin']:
				return 'Login Successful'
			else:
				return 'Login Failed'

		except:
			return 'Email Not on File'

		cur.close()







@app.route('/CorkboardStats')
def CorkboardStats():
	return render_template('ViewCorkboardStats.html')

@app.route('/CorkboardStats', methods=['POST','GET'])
def CorkboardStatsView():

	# session['email'] = email

	if request.method == 'POST':

		cur = mysql.connection.cursor()

		rows = cur.execute("SELECT CONCAT(fname, ' ', lname) AS Name, (SELECT COUNT(*) FROM PublicCorkboard WHERE owner_email = c.email) AS pub_cork_count,(SELECT COUNT(*) FROM PrivateCorkboard WHERE owner_email = c.email) AS prv_cork_count,(SELECT COUNT(*) FROM PublicCorkboard NATURAL JOIN Pushpin WHERE owner_email = c.email) AS pub_push_count,(SELECT COUNT(*) FROM PrivateCorkboard NATURAL JOIN Pushpin WHERE owner_email = c.email) AS prv_push_count FROM User AS c GROUP BY email ORDER BY pub_cork_count, prv_cork_count DESC");

		data = cur.fetchall()

		print(data[0])
		# for i in data:
		# 	print(i)
		# 	print(type(i))
		current_user = 'Hoho Banks'

		return render_template('ViewCorkboardStats.html', result = data, current = current_user)







@app.route('/PopularTags')
def TagStats():
	return render_template('PopularTags.html')

@app.route('/PopularTags', methods=['POST','GET'])
def TagStatsView():
	if request.method == 'POST':

		cur = mysql.connection.cursor()

		rows = cur.execute("SELECT tag, COUNT(tag) AS PushPins, COUNT(DISTINCT corkboardID) AS Corkboards FROM TAGS NATURAL JOIN (SELECT pushpinID, corkboardID FROM PUSHPIN) AS a GROUP BY tag ORDER BY PushPins DESC, Corkboards DESC");

		data = cur.fetchall()

		print(data)


		return render_template('PopularTags.html', result = data)






@app.route('/AddPushpin')
def AddPushpin():
	return render_template('AddPushpin.html')

@app.route('/AddPushpin', methods=['POST','GET'])
def AddPushpinView():
	if request.method == 'POST':

		URL = str(request.form['URL'])
		print(URL)
		Description = str(request.form['Description'])
		print(Description)
		Tags = str(request.form['Tags'])
		Tags = Tags.split(',')
		Tags = [Tag.strip() for Tag in Tags]
		print(Tags)

		cur = mysql.connection.cursor()

		corkboardID_current = 4
		owner_current = 'jojo@gmail.com'

		cur.execute("INSERT INTO Pushpin(corkboardID, owner_email, url, description) VALUES (%s,%s,%s,%s);", (corkboardID_current,owner_current,URL,Description))

		mysql.connection.commit()

		pushpinID_current = cur.execute("SELECT pushpinID FROM Pushpin ORDER BY pushpinID DESC LIMIT 1;")
		pushpinID_current = cur.fetchall()[0]['pushpinID']
		print(pushpinID_current, type(pushpinID_current))

		for Tag in Tags:
			cur.execute("INSERT INTO Tags(tag, pushpinID) VALUE (%s,%s);", (Tag,pushpinID_current))

			mysql.connection.commit()

		test = cur.execute("SELECT * FROM Pushpin;")
		test = cur.fetchall()
		print(test)



		return render_template('AddPushpin.html')






if __name__ == '__main__':
	app.run(debug=True)
