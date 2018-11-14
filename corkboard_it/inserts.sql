INSERT INTO User(email, pin, fname, lname) VALUES
  ('jojo@gmail.com', 1234, 'Jojo', 'Banks'),
  ('coco@gmail.com', 1234, 'Coco', 'Banks'),
  ('momo@gmail.com', 1234, 'Momo', 'Banks'),
  ('hoho@gmail.com', 1234, 'Hoho', 'Banks')
;

INSERT INTO Category(category) VALUES
  ('Education'),
  ('People'),
  ('Sports'),
  ('Other'),
  ('Architecture'),
  ('Travel'),
  ('Pets'),
  ('Food & Drink'),
  ('Home & Garden'),
  ('Photography'),
  ('Technology'),
  ('Art')
;

INSERT INTO Corkboard(owner_email) VALUES
  ('coco@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'First Public Title', 'Education'
  FROM Corkboard
  WHERE owner_email = 'coco@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'coco@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('coco@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'Second Public Title', 'People'
  FROM Corkboard
  WHERE owner_email = 'coco@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'coco@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('coco@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'Third Public Title', 'Sports'
  FROM Corkboard
  WHERE owner_email = 'coco@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'coco@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('jojo@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'First Public Title', 'Sports'
  FROM Corkboard
  WHERE owner_email = 'jojo@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'jojo@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('jojo@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'Second Public Title', 'Photography'
  FROM Corkboard
  WHERE owner_email = 'jojo@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'jojo@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('jojo@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'Third Public Title', 'Food & Drink'
  FROM Corkboard
  WHERE owner_email = 'jojo@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'jojo@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('jojo@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'Fourth Public Title', 'Food & Drink'
  FROM Corkboard
  WHERE owner_email = 'jojo@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'jojo@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('momo@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'First Public Title', 'Photography'
  FROM Corkboard
  WHERE owner_email = 'momo@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'momo@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('coco@gmail.com')
;
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
  SELECT corkboardID, owner_email, 'First Private Title', 'Home & Garden', '1234'
  FROM Corkboard
  WHERE owner_email = 'coco@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'coco@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('coco@gmail.com')
;
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
  SELECT corkboardID, owner_email, 'Second Private Title', 'Travel', '1234'
  FROM Corkboard
  WHERE owner_email = 'coco@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'coco@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('coco@gmail.com')
;
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
  SELECT corkboardID, owner_email, 'Third Private Title', 'Travel', '1234'
  FROM Corkboard
  WHERE owner_email = 'coco@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'coco@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('hoho@gmail.com')
;
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
  SELECT corkboardID, owner_email, 'First Private Title', 'Home & Garden', '1234'
  FROM Corkboard
  WHERE owner_email = 'hoho@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'hoho@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('hoho@gmail.com')
;
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
  SELECT corkboardID, owner_email, 'Second Private Title', 'Travel', '1234'
  FROM Corkboard
  WHERE owner_email = 'hoho@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'hoho@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Pushpin(owner_email, corkBoardID, url, description) VALUES
  ('jojo@gmail.com', 4, 'https://akm-img-a-in.tosshub.com/indiatoday/images/story/201510/panda-story-647_100715123127.jpg', 'Once upon a time'),
  ('jojo@gmail.com', 4, 'https://cache.desktopnexus.com/cropped-wallpapers/2292/2292180-1680x1050-[DesktopNexus.com].jpg?st=0-SFUr7w4p7FQUPQEUikqw&e=1541652731', 'There was something else'),
  ('jojo@gmail.com', 5, 'https://cdnb.artstation.com/p/assets/images/images/000/679/621/large/mark-fonzen-flying-whales.jpg?1430624742', 'Everyone Knows'),
  ('hoho@gmail.com', 12, 'https://i.ebayimg.com/images/g/jNcAAOSwCA5baMhb/s-l300.jpg', 'Hello'),
  ('coco@gmail.com', 9, 'https://images-cdn.9gag.com/photo/aYw9ePx_460s.jpg', 'Supman'),
  ('coco@gmail.com', 1, 'https://images-cdn.9gag.com/photo/23925_700b.jpg', 'Whatsup')
;

INSERT INTO Watches(watcher_email, corkboardID) VALUES
  ('coco@gmail.com', 4),
  ('coco@gmail.com', 12)
;

INSERT INTO Follows(follower_email, followee_email) VALUES
  ('coco@gmail.com', 'jojo@gmail.com'),
  ('coco@gmail.com', 'momo@gmail.com')
;

INSERT INTO Tags(pushpinID, tag) VALUES
  (1, 'fiesty'),
  (1, 'croosh'),
  (1, 'Nguyening'),
  (2, 'BoJacking'),
  (3, 'BoJacking'),
  (4, 'BoJacking'),
  (4, 'Nguyening'),
  (5, 'Sammy')
;

INSERT INTO Comment(commenter_email, pushpinID, comment) VALUES
  ('coco@gmail.com', 1, 'Whatzzup bitches'),
  ('hoho@gmail.com', 1, 'Sup dude'),
  ('momo@gmail.com', 1, 'Yo yo'),
  ('coco@gmail.com', 2, 'Whatzzup bitches - Bojack')
;

INSERT INTO Likes(liker_email, pushpinID) VALUES
  ('coco@gmail.com', 1),
  ('coco@gmail.com', 2),
  ('coco@gmail.com', 3),
  ('coco@gmail.com', 4),
  ('coco@gmail.com', 5),
  ('hoho@gmail.com', 2),
  ('hoho@gmail.com', 4),
  ('hoho@gmail.com', 6),
  ('momo@gmail.com', 1),
  ('momo@gmail.com', 5)
;
