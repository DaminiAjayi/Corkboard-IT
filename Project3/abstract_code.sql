-- TASKS

-- JOSH'S TASKS ----------
-- LOGIN TO PRIVATE CORKBOARD---------------------------------------------------
SELECT password FROM PrivateCorkboard WHERE corkboardID = '$CorkboardID';

-- ADD CORKBOARD----------------------------------------------------------------
-- Read categories
SELECT category FROM Category;

-- Make a corkboard
INSERT INTO Corkboard(owner_email) VALUES ('$Email');

-- Store most recent corkboardID
SET @createdCorkboardID = (
SELECT corkboardID FROM Corkboard
WHERE owner_email = '$Email'
ORDER BY corkboardID DESC
LIMIT 1);

-- Make specific Privatecorkboard based off of radio button
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
VALUES (@createdCorkboardID, '$Email', '$Title', '$Category', '$Password');

-- PublicCorkboard Add
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category)
VALUES (@createdCorkboardID, '$Email', '$Title', '$Category');


-- VIEW HOME SCREEN-------------------------------------------------------------
-- Display User's name
SELECT CONCAT(fname, ' ', lname) AS full_name FROM `User` WHERE email = '$Email';

-- Find Corkboards that User owns; order alphabetically by title
-- Include if its a private corkboard, also calculate number of pushpins for each
SELECT title, 'private' AS type,
(SELECT COUNT(*) FROM Pushpin
WHERE owner_email = prv.owner_email
AND corkboardID = prv.corkboardID) AS pushpin_count
FROM PrivateCorkboard as prv
WHERE prv.owner_email = '$Email'
UNION ALL
SELECT title, 'public',
(SELECT COUNT(*) FROM Pushpin
WHERE owner_email = pub.owner_email
AND corkboardID = pub.corkboardID) AS pushpin_count
FROM PublicCorkboard as pub
WHERE pub.owner_email = '$Email'
ORDER BY title;

-- Find Corkboards that User owns, follows, and watches and order by most recently updated
-- UPDATED = LAST PUSHPIN TO BE ADDED TO A CORKBOARD
-- GET ALL USERS WHO HAVE A CORKBOARD WITH A PUSHPIN ON IT
SELECT user_cork_push.full_name, user_cork_push.title, user_cork_push.recent_date, user_cork_push.type
FROM (SELECT CONCAT(`User`.fname, ' ', `User`.lname) AS full_name, User.email,
pub.corkboardID, pub.title, MAX(pin.pushpin_date) AS recent_date, 'public' AS type
FROM `User`
INNER JOIN PublicCorkboard AS pub
ON pub.owner_email = `User`.email
INNER JOIN Pushpin AS pin
ON pin.owner_email = pub.owner_email
AND pin.corkboardID = pub.corkboardID
GROUP BY full_name, `User`.email,
pub.corkboardID, pub.title, type
UNION ALL
SELECT CONCAT(`User`.fname, ' ', `User`.lname) AS full_name, User.email,
prv.corkboardID, prv.title, MAX(pin.pushpin_date) AS recent_date, 'private' as type
FROM `User`
INNER JOIN PrivateCorkboard AS prv
ON prv.owner_email = `User`.email
INNER JOIN Pushpin AS pin
ON pin.owner_email = prv.owner_email
AND pin.corkboardID = prv.corkboardID
GROUP BY full_name, `User`.email,
prv.corkboardID, prv.title, type) AS user_cork_push

-- Find who someone is following and get all their corkboards that are updated
WHERE user_cork_push.email IN (
SELECT Follows.followee_email FROM Follows
INNER JOIN `User` ON `User`.email = Follows.Followee_email
WHERE Follows.follower_email = '$Email')

-- Find who someone is watching
-- Get corkboardID to reference owner of that corkboard
-- Get pushpin date from the corkboardID
OR (user_cork_push.email, user_cork_push.corkboardID) IN (
SELECT `User`.email, Corkboard.corkboardID FROM Watches
INNER JOIN Corkboard ON Corkboard.corkboardID = Watches.corkboardID
INNER JOIN `User` ON `User`.email = Corkboard.owner_email
WHERE Watches.watcher_email = '$Email')

-- Gather current users most recently updated corkboards
OR user_cork_push.email = '$Email'

-- Display formating
ORDER BY user_cork_push.recent_date DESC
LIMIT 4;


--JEFFS TASKS-----------------------
-- ADD PUSHPIN------------------------------------------------------------------
INSERT INTO Pushpin(owner_email, corkboardID, url, description)
VALUES ('$Owner_email', '$CorkboardID', '$URL', '$Description');

SET @CurrentPushpinID =
(SELECT pushpinID FROM Pushpin
ORDER BY pushpinID DESC LIMIT 1);

INSERT INTO Tags(pushpinID, tag) VALUES (@CurrentPushpinID, '$Tag');

--CORKBOARD STATS-------------------------------------
SELECT c.owner_email,
  (SELECT COUNT(*) FROM PublicCorkboard
    WHERE owner_email = c.owner_email) AS pub_cork_count,
  (SELECT COUNT(*) FROM PrivateCorkboard
    WHERE owner_email = c.owner_email) AS prv_cork_count,
  (SELECT COUNT(*) FROM PublicCorkboard
    NATURAL JOIN Pushpin
    WHERE owner_email = c.owner_email) AS pub_push_count,
  (SELECT COUNT(*) FROM PrivateCorkboard
    NATURAL JOIN Pushpin
    WHERE owner_email = c.owner_email) AS prv_push_count
FROM Corkboard as c
GROUP BY owner_email;

-- View Popular TAGS ---------------------------------------------------------
SELECT tag, COUNT(Pushpin.pushpinID) AS pushpin_count,
COUNT(DISTINCT Pushpin.corkboardID) AS corkboard_count
FROM Pushpin
INNER JOIN Tags ON Pushpin.pushpinID = Tags.pushpinID
INNER JOIN Corkboard ON Corkboard.corkboardID = Pushpin.pushpinID
GROUP BY tag;


-- DAMINI TASKS---------------
-- FOLLOW -------------------------------------------------------------------
-- Assume $Followee_email is already available from the ViewCorkboard or View Pushpin task
INSERT INTO Follows(follower_email, followee_email)
VALUES ('$Email', '$Followee_email');

-- VIEW CORKBOARD --------------------------------------------------------------
-- Assume we have '$UserID', '$CorkboardID'
SELECT fname, lname FROM `User` WHERE `User`.Email='$UserID'

SELECT title, cork_date, category FROM Corkboard
NATURAL JOIN PrivateCorkboard
WHERE owner_email = '$Email' AND corkboardID = '$CorkboardID'
UNION
SELECT title, cork_date, category FROM Corkboard
NATURAL JOIN PublicCorkboard
WHERE owner_email = '$Email' AND corkboardID = '$CorkboardID';

-- Get number of watchers
SELECT COUNT(*) FROM Watches
WHERE corkboardID = '$CorkboardID';

-- WATCH CORKBOARD -------------------------------------------------------------
INSERT INTO Watches(watcher_email, corkboardID)
VALUES ('$Email', '$CorkboardID');

-- SEARCH PUSHPINS ------------------------------------------------------------
-- Assume we have $Search_text
SELECT DISTINCT description, category, CONCAT(fname, ' ', lname) AS fullname
FROM `User`
INNER JOIN PublicCorkboard AS pub ON pub.owner_email = `User`.email
INNER JOIN Pushpin AS pin ON pin.corkboardID = pub.corkboardID
LEFT JOIN Tags ON Tags.pushpinID = pin.pushpinID
WHERE description LIKE '%$Search_text%' OR
tag LIKE '%$Search_text%' OR
category LIKE '%$Search_text%';


-- JIANDAO TASKS-----------------
-- VIEW POPULAR SITES -------------------------------------------------------
SELECT DISTINCT SUBSTRING(
  url,
  LOCATE('//', url) + 2,
  LOCATE('/', url, 8) - LOCATE('//',url) - 2
) AS PopularSite,
COUNT(*) AS CountPopularSite
FROM Pushpin
GROUP BY PopularSite
ORDER BY CountPopularSite DESC;

-- VIEW PUSHPIN --------------------------------------------------------------
-- Assume we have $PushpinID, $Owner_email and $Email
-- Hyperlink back to associated corkboard
SELECT corkboardID FROM Pushpin
WHERE pushpinID = '$PushpinID';

-- Displaying owners name
SELECT fname, lname
FROM Pushpin
INNER JOIN `User`
ON Pushpin.owner_email=`User`.email
WHERE pushpinID = '$PushpinID';


-- Follows button
SELECT *
FROM Follows
WHERE followee_email = '$Email'
AND follower_email = (
  SELECT owner_email
  FROM Pushpin
  WHERE pushpinID='$PushpinID'
);


-- Find and Display Title of PushPins CorkBoard
SELECT title
FROM Pushpin NATURAL JOIN PrivateCorkboard
WHERE pushpinID='$PushpinID'
UNION
SELECT title
FROM Pushpin NATURAL JOIN PublicCorkboard
WHERE pushpinID='$PushpinID';

-- Find the URL and display the image, display the domain name of URL, display
-- description, display when pushpin was created
SELECT url, SUBSTRING(
  url,
  LOCATE('//', url) + 2,
  LOCATE('/', url, 8) - LOCATE('//',url) - 2
) AS domain,
description, pushpin_date
FROM Pushpin
WHERE pushpinID='$PushpinID';

-- Find and display the Tag of PushPin, split by comma
SELECT tag
FROM Pushpin
LEFT OUTER JOIN Tags ON Pushpin.pushpinID = Tags.pushpinID
WHERE pushpinID='$PushpinID';

-- Display likes (button)
-- Look up current users likes:
-- If already liked:
--   Display “Unlike!” button
-- Else:
--   Display “Like!” button
SELECT *
FROM Pushpin
LEFT OUTER JOIN Likes
ON Pushpin.pushpinID = Likes.pushpinID
WHERE liker_email='$Email' AND pushpinID='$PushpinID'

-- Find and display the Comments of PushPin
--   Display Comments in order of date/time posted; most recent first
--   Display post comment button
SELECT CONCAT(fname, ' ', lname) AS fullname, comment, comment_date
FROM Pushpin
NATURAL JOIN `Comment`
LEFT OUTER JOIN `User` ON Comment.commenter_email = `User`.email
WHERE Pushpin.pushpinID = '$PushpinID'
ORDER BY comment_date DESC;

-- Displaying likers of pushpin
-- Find the User Watcher’s Email who Like the PushPin;
-- Display User Watcher’s First and Last Name;
SELECT CONCAT(fname, ' ', lname) AS fullname
FROM (Pushpin
LEFT OUTER JOIN Likes
ON Pushpin.pushpinID = Likes.pushpinID)
LEFT OUTER JOIN `User` ON liker_email = email
WHERE pushpinID='$PushpinID';


-- FOR Like/Unlike button run Like/UNLIKE TASK -----------------------

-- Find if User Watcher has liked the PushPin
SELECT *
FROM Likes
WHERE pushpinID = '$PushpinID' AND liker_email = '$Email'
--  ▪ If User Watcher has unliked the PushPin,
--  • If User Watcher click “Like!” button, Write the User Watcher into database
-- $liker_email  is email of current user
-- $PushipinID is the PushpinID of current Pushpin
INSERT INTO Likes (pushpinID, liker_email)
VALUES ('$PushpinID', '$Email')

--  If User Watcher click “Unlike!” button, remove the User Watcher from database
-- $liker_email  is email of current user
-- $PushipinID is the PushpinID of current Pushpin
DELETE FROM Likes
WHERE liker_email = '$email' AND pushpinID='$PushpinID'

-- POST COMMENT -----------------------------------------------------
INSERT INTO `Comment`(commenter_email, pushpinID, comment)
VALUES('$Email', '$PushpinID', '$Comment');
