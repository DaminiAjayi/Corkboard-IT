-- Tables and constraints

CREATE TABLE `User` (
  email VARCHAR(80) NOT NULL,
  pin INT(4) NOT NULL,
  fname VARCHAR(50) NOT NULL,
  lname VARCHAR(50) NOT NULL,
  PRIMARY KEY (email)
);

INSERT INTO `USER`(email,pin, fname, lname)
VALUES ("aaa@gmail.com","1111","a","aa"),
("bbb@gmail.com","2222","b","bb"),
("ccc@gmail.com","3333","c","cc"),
("ddd@gmail.com","4444","d","dd"),
("eee@gmail.com","5555","e","ee"),
("fff@gmail.com","6666","f","ff");


CREATE TABLE Category (
  category VARCHAR(100) NOT NULL,
  PRIMARY KEY (category)
);

INSERT INTO Category(category)
VALUES("green"),
("yellow"),
("red");

CREATE TABLE Corkboard (
  corkboardID INT(16) unsigned NOT NULL AUTO_INCREMENT,
  owner_email VARCHAR(80) NOT NULL,
  PRIMARY KEY (corkboardID, owner_email),
  FOREIGN KEY (owner_email) REFERENCES `User`(email) ON DELETE CASCADE
);

INSERT INTO Corkboard(corkboardID, owner_email)
VALUES(9001,"aaa@gmail.com"),
(9002,"bbb@gmail.com"),
(9003,"bbb@gmail.com"),
(9004,"aaa@gmail.com"),
(9005,"ddd@gmail.com"),
(9006,"fff@gmail.com");



CREATE TABLE PrivateCorkboard (
  corkboardID INT(16) unsigned NOT NULL,
  owner_email VARCHAR(80) NOT NULL,
  title VARCHAR(80) NOT NULL,
  category VARCHAR(100) NOT NULL,
  cork_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  password VARCHAR(30) NOT NULL,
  PRIMARY KEY (corkboardID, owner_email),
  FOREIGN KEY (corkboardID) REFERENCES Corkboard(corkboardID) ON DELETE CASCADE,
  FOREIGN KEY (owner_email) REFERENCES Corkboard(owner_email) ON DELETE CASCADE,
  FOREIGN KEY (category) REFERENCES Category(category)
);

INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category,password)
VALUES 
(9005,"ddd@gmail.com","submaine","green","1234"),
(9006,"fff@gmail.com","tanker","green","4321");

CREATE TABLE PublicCorkboard (
  corkboardID INT(16) unsigned NOT NULL,
  owner_email VARCHAR(80) NOT NULL,
  title VARCHAR(80) NOT NULL,
  category VARCHAR(100) NOT NULL,
  cork_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (corkboardID, owner_email),
  FOREIGN KEY (corkboardID) REFERENCES Corkboard(corkboardID) ON DELETE CASCADE,
  FOREIGN KEY (owner_email) REFERENCES Corkboard(owner_email) ON DELETE CASCADE,
  FOREIGN KEY (category) REFERENCES Category(category)
);

INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
VALUES (9001,"aaa@gmail.com","jet","red"),
(9002,"bbb@gmail.com","bike","green"),
(9004,"aaa@gmail.com","truck","yellow"),
(9003,"bbb@gmail.com","rocket","red");


CREATE TABLE Pushpin (
  pushpinID INT(16) unsigned NOT NULL AUTO_INCREMENT,
  corkboardID INT(16) unsigned NOT NULL,
  owner_email VARCHAR(80) NOT NULL,
  pushpin_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  url VARCHAR(500) NOT NULL,
  description VARCHAR(500) NOT NULL,
  PRIMARY KEY (pushpinID, corkboardID, owner_email),
  FOREIGN KEY (corkboardID) REFERENCES Corkboard(corkboardID) ON DELETE CASCADE,
  FOREIGN KEY (owner_email) REFERENCES Corkboard(owner_email) ON DELETE CASCADE
);

INSERT INTO Pushpin(pushpinID,corkboardID, owner_email, url, description)
VALUES (1001,9001,"aaa@gmail.com","http://www.youtube.com/aaa","1st pushpin"),
(1002,9001,"aaa@gmail.com","http://www.facebook.com/aaa","2nd pushpin"),
(1003,9002,"bbb@gmail.com","http://www.yahoo.com/bbb","3rd pushpin"),
(1004,9004,"aaa@gmail.com","http://www.live.com/aaa","4th pushpin"),
(1005,9003,"bbb@gmail.com","http://www.linkedin.com","5th pushpin"),
(1006,9005,"ddd@gmail.com","http://www.amazon.com/","6th pushpin"),
(1007,9003,"bbb@gmail.com","http://www.ebay.com/bbb","7th pushpin");


CREATE TABLE Tags (
  pushpinID INT(16) unsigned NOT NULL,
  tag VARCHAR(80) NOT NULL,
  PRIMARY KEY (pushpinID, tag),
  FOREIGN KEY (pushpinID) REFERENCES Pushpin(pushpinID) ON DELETE CASCADE
);

CREATE TABLE `Comment` (
  commentID INT(16) unsigned NOT NULL AUTO_INCREMENT,
  commenter_email VARCHAR(80) NOT NULL,
  pushpinID INT(16) unsigned NOT NULL,
  comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  comment VARCHAR(500) NOT NULL,
  PRIMARY KEY (commentID, commenter_email, pushpinID),
  FOREIGN KEY (commenter_email) REFERENCES `User`(email) ON DELETE CASCADE,
  FOREIGN KEY (pushpinID) REFERENCES Pushpin(pushpinID) ON DELETE CASCADE
);

CREATE TABLE Follows (
  follower_email VARCHAR(80) NOT NULL,
  followee_email VARCHAR(80) NOT NULL,
  PRIMARY KEY (follower_email, followee_email),
  FOREIGN KEY (follower_email) REFERENCES `User`(email) ON DELETE CASCADE,
  FOREIGN KEY (followee_email) REFERENCES `User`(email) ON DELETE CASCADE
);

CREATE TABLE Watches (
  watcher_email VARCHAR(80) NOT NULL,
  corkboardID INT(16) unsigned NOT NULL,
  PRIMARY KEY (watcher_email, corkboardID),
  FOREIGN KEY (watcher_email) REFERENCES `User`(email) ON DELETE CASCADE,
  FOREIGN KEY (corkboardID) REFERENCES Corkboard(corkboardID) ON DELETE CASCADE
);

CREATE TABLE Likes (
  liker_email VARCHAR(80) NOT NULL,
  pushpinID INT(16) unsigned NOT NULL,
  PRIMARY KEY (liker_email, pushpinID),
  FOREIGN KEY (liker_email) REFERENCES `User`(email) ON DELETE CASCADE,
  FOREIGN KEY (pushpinID) REFERENCES Pushpin(pushpinID) ON DELETE CASCADE
);
