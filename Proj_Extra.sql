# This script contains the queries that were written in the project description.




# Use the required database
USE allotment;


# ************** This is the STUDENT REGISTRATION module.  It is necessary to use all the three procedure for proper allotment **********
# Procedure 1. This procedure adds the details of the student
	# drop the procedure if it already exists
	DROP PROCEDURE IF EXISTS register_student;
	# create the procedure
	DELIMITER $$
	CREATE PROCEDURE register_student(IN first_name VARCHAR(20), last_name VARCHAR(20),app_no INT UNSIGNED, state VARCHAR(30),age INT UNSIGNED, percentile DECIMAL(5 , 2 ))
	BEGIN
	INSERT INTO student VALUES (first_name,last_name, app_no, state, age,percentile);
	END $$
	DELIMITER ;
    # call the procedure
    CALL register_student('Poojan', 'Gandhi', 1700, 'Gujarat',20,91);
    
# Procedure 2. This procedure add the marks of subject scored by student in class 12
# Drop the procedure if it already exists
	DROP PROCEDURE IF EXISTS add_sub_marks;
	# create the procedure
	DELIMITER $$
	CREATE PROCEDURE add_sub_marks(IN app_no INT UNSIGNED,subject VARCHAR(20), marks DECIMAL(5 , 2 ))
	BEGIN
	INSERT INTO sub_marks VALUES (app_no, subject, marks);
	END $$
	DELIMITER ;
    # call the procedure. Remember you can add more subjects by repeatedly calling add_sub_marks procedure.
    CALL add_sub_marks( 1700, 'Mathematics',90);
    
# Procedure 3. This procedure adds the preference of the student in decreasing order of priority.
# Drop the procedure if it already exists
	DROP PROCEDURE IF EXISTS add_pref;
	# create the procedure
	DELIMITER $$
	CREATE PROCEDURE add_pref(IN application INT UNSIGNED, college_id INT UNSIGNED, branch_id VARCHAR(5))
	BEGIN
    DECLARE pref_rank INT UNSIGNED;
    SET pref_rank = (select count(*) from prefers where app_no = application) + 1; # Setting the pref_rank depending on number of previous pref 
	INSERT INTO prefers VALUES (application, college_id, branch_id, pref_rank);
	END $$
	DELIMITER ;
    # call the procedure. 
    # *********Remember you can only enter those college and branch where college offers that branch, otherwise error is shown************
    CALL add_pref( 1700, '111','math');
    
    
# ********** Student registration module finished ***************





# ************** This is the COLLEGE REGISTRATION module.  It is necessary to use all the three procedure for proper allotment **********
# Procedure 1. This procedure adds the details of the college
	# drop the procedure if it already exists
	DROP PROCEDURE IF EXISTS register_college;
	# create the procedure
	DELIMITER $$
	CREATE PROCEDURE register_college(IN college_id INT UNSIGNED, name VARCHAR(50), state VARCHAR(30))
	BEGIN
	INSERT INTO college VALUES (college_id, name, state);
	END $$
	DELIMITER ;
    # call the procedure
    CALL register_college(190, 'Delhi University', 'Delhi');
    
# Procedure 2. This procedure add the branch offered by the college
# Drop the procedure if it already exists
	DROP PROCEDURE IF EXISTS add_col_branch;
	# create the procedure
	DELIMITER $$
	CREATE PROCEDURE add_col_branch(IN college_id INT UNSIGNED, branch_id VARCHAR(5), res_seats INT UNSIGNED, unres_seats INT UNSIGNED, percentile_cutoff DECIMAL(5 , 2 ), res_alloted INT UNSIGNED , unres_alloted INT UNSIGNED)
	BEGIN
	INSERT INTO offers VALUES (college_id, branch_id, res_seats,unres_seats, percentile_cutoff, res_alloted, unres_alloted);
	END $$
	DELIMITER ;
    # call the procedure. Remember you can add more branch by repeatedly calling add_col_branch procedure.
    CALL add_col_branch(190,'cse',1,1,72,0,0);
    
# Procedure 3. This procedure adds the subject cutoff for the specific branch
# Drop the procedure if it already exists
	DROP PROCEDURE IF EXISTS add_sub_cutoff;
	# create the procedure
	DELIMITER $$
	CREATE PROCEDURE add_sub_cutoff(IN branch_id VARCHAR(5), college_id INT UNSIGNED, subject VARCHAR(20), marks DECIMAL(5 , 2 ))
	BEGIN
	INSERT INTO sub_cutoff VALUES (branch_id, college_id, subject, marks);
	END $$
	DELIMITER ;
    # call the procedure. *********Remember you can only enter those college and branch where college offers that branch, otherwise error is shown************
    CALL add_sub_cutoff( 'cse', '190','Mathematics', 78);
# ********** College registration module finished ***************








# ************* This is the  College Allotment Module ******************* 
# The allot_all procedure allots all the students into the colleges according to preference and eligibility
# ********To use this procedure one must run allot procedure (query 4) in proj_query file***********
# drop the procedure if it already exists
DROP PROCEDURE IF EXISTS allot_all;
# create the procedure
delimiter $$
create procedure allot_all()
begin
declare count int unsigned;
declare application int unsigned;
set count = 0; # setting a variable to use it as offset in the query
loop_out: loop  # loop to get one student one by one 
	if count < (select count(*) from student) then   # checks if all the students are alloted seats or not. If not allots the seat to next student
		set application = (select app_no from student order by percentile desc limit 1 offset count); # allotment is done in desecnding order of percentile
		call allot(application); # call the allot procedure
		set count = count + 1;
	else
		select 'Sucessfully Alloted Seats' as Message;
		leave loop_out;
	end if;
end loop loop_out;
end $$
delimiter ;
# call the procedure
call allot_all();

# **************** College Allotment module finished *****************






 #  ************** This is the result declaration module ******************
# The show_results procedure shows the results of the allocation of all students
# Drop the procedure if it already exists 
DROP PROCEDURE IF EXISTS show_result;
# Create procedure
delimiter $$
create procedure show_result()
begin
    # Selecting the required fields after joining allotment, student, college and branch table
	select A.app_no as 'Application Number', concat(A.first_name, ' ', A.last_name) as Name, concat(B.college_id, ': ', B.college) as College, concat(B.branch_id, ': ',B.offers) as 'Alloted Branch' from 
		student A
	join
        (select E.app_no, E.college_id, E.name as college, H.branch_id, H.name as offers from 
			(select C.college_id, D.name, C.app_no from allotment C join college D where C.college_id=D.college_id) E
		join
			(select F.app_no, F.branch_id, G.name from allotment F join branch G where F.branch_id=G.branch_id) H
		where E.app_no=H.app_no) B
	where A.app_no=B.app_no;
end $$
delimiter ;
# Call the procedure
call show_result();



# The show_result_app procedure shows the result of allotment of a particular student 
# Drop the procedure if it already exists 
DROP PROCEDURE IF EXISTS show_result_app;
# Create procedure
delimiter $$
create procedure show_result_app(IN application INT UNSIGNED)
begin
    # Selecting the required fields after joining allotment, student, college and branch table
	select A.app_no as 'Application Number', concat(A.first_name, ' ', A.last_name) as Name, concat(B.college_id, ': ', B.college) as College, concat(B.branch_id, ': ',B.offers) as 'Alloted Branch' from 
		student A
	join
        (select E.app_no, E.college_id, E.name as college, H.branch_id, H.name as offers from 
			(select C.college_id, D.name, C.app_no from allotment C join college D where C.college_id=D.college_id) E
		join
			(select F.app_no, F.branch_id, G.name from allotment F join branch G where F.branch_id=G.branch_id) H
		where E.app_no=H.app_no) B
	where A.app_no=B.app_no and A.app_no = application;
end $$
delimiter ;
# Call the procedure
call show_result_app(1135);

# *********** Result declaration module finished *****************







# ****************** This Module shows relevant statistics *************
# The following procedure shows how many student registered, college registered, how many student were alloted seats 
# Drop procedure if it exists
DROP PROCEDURE IF EXISTS result_stats;
# Create procedure
delimiter $$
create procedure result_stats()
begin
select (select count(*) from student) as 'Total No. of Applications', (select count(*) from college) as 'Total No. of College' ,(select count(*) from allotment) as 'Total No. of Seats Alotted';
end $$
delimiter ;
# Call the procedure
call result_stats();





# The folowing procedure shows how many reserved and unreserved seats are filled for a paricular college but for all branches
# Drop the procedure if it exits
DROP PROCEDURE IF EXISTS college_stats;
# Create the procedure 
delimiter $$
create procedure college_stats(IN college int unsigned)
begin
select concat(A.college_id, ': ', B.name) as College, concat(A.branch_id, ': ', A.name) as Branch, A.res_alloted as 'Domicile Seats Alloted', A.unres_alloted as 'General Seats Alloted' from 
	(select C.college_id, C.branch_id, C.res_alloted, C.unres_alloted, D.name from offers C join branch D where C.branch_id=D.branch_id )A 
join 
	college B 
where (A.college_id=B.college_id and A.college_id=college);
end $$
delimiter ;
# call the procedure 
call college_stats(184);

# ************* Relevant statistic module finished ******************





