-- Tables and constraints

CREATE TABLE `User` (
  email VARCHAR(80) NOT NULL,
  pin INT(4) NOT NULL,
  fname VARCHAR(50) NOT NULL,
  lname VARCHAR(50) NOT NULL,
  PRIMARY KEY (email)
);

CREATE TABLE Category (
  category VARCHAR(100) NOT NULL,
  PRIMARY KEY (category)
);

CREATE TABLE Corkboard (
  corkboardID INT(16) unsigned NOT NULL AUTO_INCREMENT,
  owner_email VARCHAR(80) NOT NULL,
  PRIMARY KEY (corkboardID, owner_email),
  FOREIGN KEY (owner_email) REFERENCES `User`(email) ON DELETE CASCADE
);

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
