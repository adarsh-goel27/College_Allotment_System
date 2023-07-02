# Drop the database if it exists previously.
DROP DATABASE IF EXISTS allotment;

# Creating a database with name allotment. This database will store all the required tables.
CREATE DATABASE `allotment` /*!40100 DEFAULT CHARACTER SET
	utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT
	ENCRYPTION='N' */;

# Setting default schema to allotment database
USE allotment;

# Creating student table. Refer to documentation for more details.
CREATE TABLE student 
(
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20),
    app_no INT UNSIGNED,
    state VARCHAR(30),
    age INT UNSIGNED CHECK(age >= 18) NOT NULL,
    percentile DECIMAL(5 , 2 ),
    PRIMARY KEY (app_no),
    UNIQUE(percentile)
);

# Creating sub_marks table. Refer to documentation for more details.
CREATE TABLE sub_marks 
(
    app_no INT UNSIGNED,
    subject VARCHAR(20),
    marks DECIMAL(5 , 2 ) NOT NULL CHECK(marks >= 0 AND marks <=100),
    PRIMARY KEY (app_no , subject),
    FOREIGN KEY (app_no)
        REFERENCES student (app_no) ON DELETE CASCADE  
);

# Creating college table. Refer to documentation for more details.
CREATE TABLE college 
(
    college_id INT UNSIGNED,
    name VARCHAR(50) NOT NULL UNIQUE,
    state VARCHAR(30) NOT NULL,
    PRIMARY KEY (college_id)
);

# Creating branch table. Refer to documentation for more details.
CREATE TABLE branch 
(
    branch_id VARCHAR(5),
    name VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (branch_id)
);

# Creating offers table. Refer to documentation for more details.
CREATE TABLE offers 
(
    college_id INT UNSIGNED,
    branch_id VARCHAR(5),
    res_seats INT UNSIGNED NOT NULL,
    unres_seats INT UNSIGNED NOT NULL,
    percentile_cutoff DECIMAL(5 , 2 ) NOT NULL CHECK(percentile_cutoff >=0 AND percentile_cutoff <=100),
    res_alloted INT UNSIGNED NOT NULL DEFAULT 0,
    unres_alloted INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (college_id , branch_id),
    FOREIGN KEY (college_id)
        REFERENCES college (college_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id)
        REFERENCES branch (branch_id) ON DELETE CASCADE  
);

# Creating sub_cutoff table. Refer to documentation for more details.
CREATE TABLE sub_cutoff 
(
    branch_id VARCHAR(5),
    college_id INT UNSIGNED,
    subject VARCHAR(20),
    marks DECIMAL(5 , 2 ) NOT NULL CHECK (marks >=0 AND marks <=100),
    PRIMARY KEY (branch_id , college_id , subject),
    FOREIGN KEY (college_id, branch_id)
        REFERENCES offers(college_id,branch_id) ON DELETE CASCADE
);

# Creating prefers table. Refer to documentation for more details.
CREATE TABLE prefers 
(
    app_no INT UNSIGNED,
    college_id INT UNSIGNED,
    branch_id VARCHAR(5),
    pref_rank INT UNSIGNED,
    PRIMARY KEY (app_no , college_id , branch_id),
    UNIQUE (app_no, pref_rank),
    FOREIGN KEY (app_no)
        REFERENCES student (app_no) ON DELETE CASCADE,
    FOREIGN KEY (college_id, branch_id)
        REFERENCES offers (college_id, branch_id) ON DELETE CASCADE  
);

# Creating allotment table. Refer to documentation for more details.
CREATE TABLE allotment 
(
    app_no INT UNSIGNED,
    college_id INT UNSIGNED NOT NULL,
    branch_id VARCHAR(5) NOT NULL,
    PRIMARY KEY (app_no),
    FOREIGN KEY (app_no)
        REFERENCES student (app_no) ON DELETE CASCADE,
    FOREIGN KEY (college_id, branch_id)
        REFERENCES offers (college_id, branch_id) ON DELETE CASCADE 
);