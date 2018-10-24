from flask import Flask, render_template, request
from flask_mysqldb import MySQL
import yaml

app=Flask(__name__)
db=yaml.load(open('templates\db.yaml'))
app.config['MYSQL_HOST']=db['mysql_host']
app.config['MYSQL_PORT']=db['mysql_port']
app.config['MYSQL_USER']=db['mysql_user']
app.config['MYSQL_PASSWORD']=db['mysql_password']
app.config['MYSQL_DB']=db['mysql_db']

mysql=MySQL(app)

@app.route('/login',methods=["GET","POST"])
def login():
    if request.method=="POST":
        email=request.form['email']
        pin_candidate=request.form['pin']
        # Create cursor
        cur=mysql.connection.cursor()
        result=cur.execute("SELECT * FROM user WHERE email=%s",[email])
        if result>0:
            data=cur.fetchone()
            pin=data[1]
            if pin_candidate==str(pin):
                print("success")
            else:
                return "Email or pin code does not match"
    return render_template("login.html")

@app.route('/pushpin')
def pushpin():
    pushpinID=1001;
    cur=mysql.connection.cursor()
    result=cur.execute("SELECT fname, lname FROM Pushpin INNER JOIN `User`ON Pushpin.owner_email=`User`.email WHERE pushpinID =%s",[pushpinID])
    if result>0:
        data=cur.fetchone()
        fname=data[0]
        lname=data[1]
    cur=mysql.connection.cursor()
    result=cur.execute("SELECT title FROM Pushpin NATURAL JOIN PrivateCorkboard\
    WHERE pushpinID='$PushpinID'UNION SELECT title FROM Pushpin NATURAL JOIN PublicCorkboard WHERE pushpinID=%s",[pushpinID])
    if result>0:
        data=cur.fetchone()
        title=data[0]
    return render_template("pushpin.html",fname=fname,lname=lname,title=title)


if __name__=='__main__':
    app.run(debug=True)
