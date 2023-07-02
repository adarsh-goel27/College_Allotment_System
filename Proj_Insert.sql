# Selecting the required database.
use allotment;

# Delete all the previous records in all the tables. Comment the following truncate statement if error is shown.
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE student;
TRUNCATE TABLE sub_marks;
TRUNCATE TABLE college;
TRUNCATE TABLE branch;
TRUNCATE TABLE sub_cutoff;
TRUNCATE TABLE prefers;
TRUNCATE TABLE offers;
TRUNCATE TABLE allotment;
SET FOREIGN_KEY_CHECKS = 1;

# Inserting values into student table.
INSERT INTO student VALUES
('Adarsh','Goel',1135,'Uttar Pradesh',21,99.71), ('Arjoo','Kumari', 1234,'Rajasthan',20,99.5), ('Chinmay','Anand',1200,'Jharkhand',21, 99), 
('Kshitij','Tandon',1000,'Uttar Pradesh',21,98.7), ('Praneet','Karna',1300,'Bagmati',21,91.1), ('Ashwin', 'Kothari',1435,'Karnataka',19, 70),
('Vedant','Bansal', 1400,'Punjab',20,76), ('Rudresh','Patel', 1500,'Gujarat',19,85), ('Jaysheel','Shah', 1535, 'Gujarat', 23, 90),
('Devashish','Siwatch', 1600, 'Haryana', 21, 92) ;

# Inserting values into sub_marks table. Here, the marks of all subjects in 12th class is entered here for each student.
INSERT INTO sub_marks VALUES
(1135,'Physics',100), (1135, 'Computer Science', 100),(1135,'Chemistry', 99), (1234, 'Mathematics', 99), (1234, 'Biology', 98), 
(1200, 'Physics', 55), (1200,'Mathematics',100), (1000, 'English Literature',95), (1000,'Chemistry', 60),(1000,'Physics', 95),
(1300,'Physics',78), (1300,'Computer Science', 95),(1300,'Mathematics',90), (1435,'Physical Education',92),(1435,'Biology', 69),(1435,'Chemistry',82),
(1400,'Mathematics',73), (1400,'Chemistry', 78), (1500,'Computer Science', 89),(1500,'Physics', 90), (1500,'Mathematics',76),
(1535,'Chemistry',79),(1535,'Mathematics',84), (1600,'Economics',100);

# Inserting values into college table.
INSERT INTO college VALUES
(113,'Indian Institute of Technology, Delhi', 'Delhi'), (120, 'Birla Institute of Technology, Pilani','Rajasthan'), 
(184, 'Thapar Institute of Technology', 'Punjab'),(130,'Indian Institute of Technology, Gandhinagar','Gujarat'),
(121,'Birla Institute of Technology, Goa','Goa'), (122, 'Birla Institute of Technology, Hyderabad', 'Telangana'),
(112, 'Indian Institute of Technology, Bombay', 'Maharastra'), (111, 'Indian Institute of Technology, Madras', 'Tamil Nadu'),
(141, 'Lucknow University', 'Uttar Pradesh'), (151,'Punjab University', 'Punjab');

# Inserting values into branch table.
INSERT INTO branch VALUES
('cse', 'Computer Science and Engineering'), ('ece', 'Electronics and Communications Engineering'), 
('eee', 'Electrical and Electronics Engineering'), ('me','Mechanical Engineering'), 
('mne', 'Manufacturing Engineering'),('eco', 'Economics'),
('math','Mathematics'),('ce','Chemical Engineering'),
('bio', 'Biology'), ('phy','Physics');

# Inserting values into offers table. Note some college has already some filled seats.
INSERT INTO offers VALUES
(113,'cse',1,2,90,1,0), (113,'eee',1,1,90,1,1), (120,'ece',1,1,92,0,0), 
(120,'me',1,1,92,0,0), (184,'eco',1,1,0,0,0),(184,'cse',1,1,0,0,0),(184,'bio',1,1,60,0,1),
(130,'math',1,1,75.00,0,0),(121,'cse',1,1,90.00,1,0),(121,'bio',1,1,50.00,0,0),(122,'phy',1,1,70,0,0),
(122,'ece',1,1,99.00,0,0),(112,'eee',1,2,90.00,0,0),(112,'phy',1,1,70.00,0,0),(111,'mne',1,1,60.00,1,1),
(111,'math',1,1,65.00,1,1),(141,'cse',1,1,50.00,0,0),(141,'ce',1,1,45,0,0),
(151,'ece',1,1,92.00,0,0),(151,'math',1,1,50.00,0,0);

# Inserting values into sub_cutoff table.
INSERT INTO sub_cutoff VALUES
('cse', 113, 'Physics', 75), ('cse', 113, 'Computer Science', 95), ('eee', 112, 'Mathematics', 90), ('cse', 184, 'Physics', 75), 
('cse', 184, 'Mathematics', 85), ('phy', 112, 'Physics', 50), ('ece', 122, 'Chemistry', 50), ('ece', 122, 'Physics', 94), ('cse', 141, 'Physics', 80),
('cse', 141, 'English Literature', 50), ('eco', 184, 'Economics', 90), ('me', 120, 'Mathematics', 75), ('me', 120, 'Chemistry', 75),  
('math', 130, 'Mathematics', 75),('math', 151, 'Mathematics', 70), ('math', 151, 'Chemistry', 75);

# Inserting values into prefers table. Remember you can only enter those combination of college_id and branch_id that are mentioned in offers
# due to foreign key contraint.
INSERT INTO prefers VALUES
(1135,113,'cse', 1), (1135,120,'ece',2), (1135, 184, 'cse', 3), 
(1234, 113, 'cse', 1), (1234, 112, 'eee',2), (1234, 120, 'me',3), 
(1200, 113,'cse', 1), (1200, 184, 'cse', 2), (1200, 112, 'phy', 3), 
(1000, 122, 'ece', 1),(1000, 141, 'cse',2), 
(1600, 112, 'eee',1), (1600, 113, 'cse',2), (1600,184,'eco',3), 
(1535,120,'me',1), (1535,130, 'math',2),
(1500,130,'math',1),
(1400,184,'cse',1),(1400, 113,'cse', 2),(1400,151,'math',3),
(1435,151,'ece',1),(1435,121,'bio',2),
(1300,151,'ece',1),(1300,120,'ece',2),(1300,113,'cse',3);

# See all the table with their values
SELECT * FROM student;
SELECT * FROM sub_marks;
SELECT * FROM college; 
SELECT * FROM branch;
SELECT * FROM offers;
SELECT * FROM sub_cutoff;
SELECT * FROM prefers;    
