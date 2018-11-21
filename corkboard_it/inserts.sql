INSERT INTO User(email, pin, fname, lname) VALUES
  ('jojo@gmail.com', 1234, 'Jojo', 'Banks'),
  ('coco@gmail.com', 1234, 'Coco', 'Banks'),
  ('momo@gmail.com', 1234, 'Momo', 'Banks'),
  ('hoho@gmail.com', 1234, 'Hoho', 'Banks'),
  ('pricesskitty@gmail.com', 1234, 'Princess', 'Carolyn'),
  ('toddchavez@gmail.com', 1234, 'Todd', 'Chavez'),
  ('bojack@gmail.com', 1234, 'Bojack', 'Horseman'),
  ('dianenugyen@gmail.com', 1234, 'Diane', 'Nguyen'),
  ('peanutbutter@gmail.com', 1234, 'Mr.', 'Peanutbutter'),
  ('sarahlynn@gmail.com', 1234, 'Sarah', 'Lynn')
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
  SELECT corkboardID, owner_email, 'My first corkboard', 'Education'
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
  SELECT corkboardID, owner_email, 'I can not believe this', 'People'
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
  SELECT corkboardID, owner_email, 'Definitely trying new things', 'Sports'
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
  SELECT corkboardID, owner_email, 'Yes my first corkboard', 'Sports'
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
  SELECT corkboardID, owner_email, 'I definitely love photos', 'Photography'
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
  SELECT corkboardID, owner_email, 'Nom Nom Nom', 'Food & Drink'
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
  SELECT corkboardID, owner_email, 'More Noms', 'Food & Drink'
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
  SELECT corkboardID, owner_email, 'Another first attempt', 'Photography'
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
  SELECT corkboardID, owner_email, 'No One Should See This', 'Home & Garden', '1234'
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
  SELECT corkboardID, owner_email, 'No one knows where I travel', 'Travel', '1234'
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
  SELECT corkboardID, owner_email, 'Just some adventures', 'Travel', '1234'
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
  SELECT corkboardID, owner_email, 'First Private Corkboard', 'Home & Garden', '1234'
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
  SELECT corkboardID, owner_email, 'Where to next', 'Travel', '1234'
  FROM Corkboard
  WHERE owner_email = 'hoho@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'hoho@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('pricesskitty@gmail.com')
;
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
  SELECT corkboardID, owner_email, 'No messing around', 'Sports', '1234'
  FROM Corkboard
  WHERE owner_email = 'pricesskitty@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'pricesskitty@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('pricesskitty@gmail.com')
;
INSERT INTO PrivateCorkboard(corkboardID, owner_email, title, category, password)
  SELECT corkboardID, owner_email, 'I care about my privacy', 'People', '1234'
  FROM Corkboard
  WHERE owner_email = 'pricesskitty@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'pricesskitty@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('toddchavez@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'When you live on a couch', 'Art'
  FROM Corkboard
  WHERE owner_email = 'toddchavez@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'toddchavez@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('toddchavez@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'What if we had dentist clowns', 'Photography'
  FROM Corkboard
  WHERE owner_email = 'toddchavez@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'toddchavez@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('bojack@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'What is the point', 'Architecture'
  FROM Corkboard
  WHERE owner_email = 'bojack@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'bojack@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;
INSERT INTO Corkboard(owner_email) VALUES
  ('bojack@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'No one believes me', 'Sports'
  FROM Corkboard
  WHERE owner_email = 'bojack@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'bojack@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;

INSERT INTO Corkboard(owner_email) VALUES
  ('dianenugyen@gmail.com')
;
INSERT INTO PublicCorkboard(corkboardID, owner_email, title, category)
  SELECT corkboardID, owner_email, 'Writing about Bojack', 'People'
  FROM Corkboard
  WHERE owner_email = 'dianenugyen@gmail.com' and corkboardID = (
    SELECT corkboardID FROM Corkboard
    WHERE owner_email = 'dianenugyen@gmail.com'
    ORDER BY corkboardID DESC
    LIMIT 1
  )
;


INSERT INTO Pushpin(owner_email, corkBoardID, url, description) VALUES
  ('jojo@gmail.com', 4, 'https://akm-img-a-in.tosshub.com/indiatoday/images/story/201510/panda-story-647_100715123127.jpg', 'Pandas love bamboo');
INSERT INTO Pushpin(owner_email, corkBoardID, url, description) VALUES
  ('jojo@gmail.com', 4, 'https://m.media-amazon.com/images/M/MV5BYTdmOTljNGUtMGJkMC00MmE2LTkwYzEtNmVlYjBmZjliNTlkXkEyXkFqcGdeQW1yb3NzZXI@._V1_UX477_CR0,0,477,268_AL_.jpg', 'Mummified');
INSERT INTO Pushpin(owner_email, corkBoardID, url, description) VALUES
  ('jojo@gmail.com', 5, 'https://occ-0-987-990.1.nflxso.net/art/b2674/8d167153ad96a7e7620aa8393f46ce8c0e3b2674.jpg', 'Todd Loves His Cereal');
INSERT INTO Pushpin(owner_email, corkBoardID, url, description) VALUES
  ('momo@gmail.com', 8, 'https://pixel.nymag.com/imgs/daily/vulture/2018/08/31/bojack/bojack-horseman-502.w700.h700.jpg', 'Well this is awkward');
INSERT INTO Pushpin(owner_email, corkBoardID, url, description) VALUES
  ('coco@gmail.com', 9, 'https://studybreaks.com/wp-content/uploads/2018/06/bojack-horseman.png', 'Bojack needs gardening advice');
INSERT INTO Pushpin(owner_email, corkBoardID, url, description) VALUES
  ('coco@gmail.com', 1, 'https://pbs.twimg.com/media/CpWZSJTXEAA7wCT.jpg', 'Are they studying?');

INSERT INTO Watches(watcher_email, corkboardID) VALUES
  ('coco@gmail.com', 4),
  ('coco@gmail.com', 12)
;

INSERT INTO Follows(follower_email, followee_email) VALUES
  ('coco@gmail.com', 'jojo@gmail.com'),
  ('coco@gmail.com', 'momo@gmail.com')
;

INSERT INTO Tags(pushpinID, tag) VALUES
  (1, 'pandas'),
  (1, 'food'),
  (1, 'cute'),
  (2, 'halloween'),
  (2, 'mummies'),
  (2, 'glowing'),
  (2, 'bojack'),
  (3, 'yum'),
  (3, 'todd'),
  (4, 'mrpeanutbutter'),
  (4, 'awkward'),
  (4, 'questionmark'),
  (5, 'classic'),
  (5, 'cute'),
  (5, 'nguyen'),
  (5, 'bojack'),
  (6, 'library'),
  (6, 'sneaky'),
  (6, 'bojack'),
  (6, 'sarah')
;

INSERT INTO Comment(commenter_email, pushpinID, comment) VALUES
  ('coco@gmail.com', 1, 'First pushpin ever!'),
  ('hoho@gmail.com', 1, 'How are you coco'),
  ('momo@gmail.com', 1, 'This is so exciting'),
  ('sarahlynn@gmail.com', 1, 'what about this panda!'),
  ('bojack@gmail.com', 2, 'I remember this')
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
