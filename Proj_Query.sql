# set the database
USE allotment;

# Query 1 present in file Proj_Create



# Query 2 (Multiple records are added in file Proj_Insert). Following query is an example.
	# *****Remember to delete this record to get consistent result as we have not added values for preference for this person*******
	INSERT INTO student VALUES
	('Jash','Ranipa',1635,'Gujarat',20,94);
	# ***********To delete this record run the following query.*********
    DELETE FROM  student WHERE app_no = 1635;



# Query 3 (Multiple records are added in file Proj_Insert). Following query is an example.
	# ******Remember to delete this record to get consistent result as we have not added values for branch offered by this college.*******
	INSERT INTO college VALUES
	(170,'Hyderabad University', 'Telangana');
	# *********To delete this record run the following query.***********
    DELETE FROM  college WHERE college_id = 170;





# Query 4. For this query a procedure is created. Call the procedure after this procedure definition. 
# ***********This is a long procedure. Run the procedure. Jump to line 228 directly******
# Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS allot;
delimiter $$
create procedure allot(IN application int unsigned)
begin
	declare top int unsigned;  # declaring a top variable to choose preference one by one of particular applicant
    set top = 1;
    loop1: loop    # loop for choosing preference one by one
    
    # checks if student has already been alloted seat. If the student is already alloted then return.
    if not isnull((select app_no from allotment where app_no=application)) then
		leave loop1;
	end if;
    
    # checks if all the preferences have been exausted or not. If all the preferences are exhausted then return.
    if isnull((select pref_rank from prefers where (pref_rank = top and app_no=application))) then
		leave loop1;
	end if;
    
    # checks if the student falls under domicile reservation or not, 
    # if not reserved enters the if statement
    if isnull((select A.state from
				(select state from student where app_no = application) A
				join 
				(select state from college 
					where college_id = (select college_id from prefers where (pref_rank = top and app_no=application))) B
				where A.state=B.state)) then
                
		# checks if unreserved seats for the given preference are completely filled or not
        # if not fully filled enters the if statement
		if not isnull((SELECT unres_seats 
		            from (select unres_seats 
					from offers 
                    where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
						   and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) A 
			        join
			        (select unres_alloted
				     from offers
                     where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
						    and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) B
			        where A.unres_seats>B.unres_alloted)) then
			
            # checks if the student satisfies the percentile cutoff for the branch
			if not isnull((select A.percentile from
						(select percentile from student where app_no=application) A 
						join
						(select percentile_cutoff from offers 
						where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
								and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) B
						where A.percentile>=B.percentile_cutoff)) then
				
                # checks if the student clears the eligibilty of subject cutoffs
                # if clears the eligibility then allots the seats, updates the no of alloted seats and leaves the loop
				if not isnull((select alpha.A from
								(select count(*) as A from sub_cutoff where (
													branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
														and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) alpha
								join
								(select count(*) as B from
											(select * from sub_cutoff where (
													branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
														and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) A
											join
											(select * from sub_marks where (app_no = application)) B
											where (A.subject = B.subject and A.marks<=B.marks)) beta
								where alpha.A = beta.B)) then
									insert into allotment values (application, 
																(select college_id from prefers where (app_no = application and pref_rank = top)), 
																(select branch_id from prefers where (app_no = application and pref_rank = top)));
									update offers set unres_alloted = unres_alloted+1 
									where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
											and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)));
									leave loop1;
				else
					set top = top+1;
				end if;
			else
				set top = top+1;
			end if;
		else
			set top = top+1;
		end if;
	else
		
        # checks if reserved seats for the given preference are completely filled or not
        # if not fully filled enters the if statement
        if not isnull((SELECT res_seats 
		            from (select res_seats 
					from offers 
                    where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
						   and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) A 
			        join
			        (select res_alloted
				     from offers
                     where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
						    and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) B
			        where A.res_seats>B.res_alloted)) then
			
            # checks if the student clears the percentile cutoff
            # enters the if statement if it clears
			if not isnull((select A.percentile from
						(select percentile from student where app_no=application) A 
						join
						(select percentile_cutoff from offers 
						where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
								and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) B
						where A.percentile>=B.percentile_cutoff)) then
                        
				# checks if the student clears the eligibilty of subject cutoffs
                # if clears the eligibility then allots the seats, updates the no of alloted seats and leaves the loop
				if not isnull((select alpha.A from
								(select count(*) as A from sub_cutoff where (
													branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
														and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) alpha
								join
								(select count(*) as B from
											(select * from sub_cutoff where (
													branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
														and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) A
											join
											(select * from sub_marks where (app_no = application)) B
											where (A.subject = B.subject and A.marks<=B.marks)) beta
								where alpha.A = beta.B)) then
                                
							insert into allotment values (application, 
														  (select college_id from prefers where (app_no = application and pref_rank = top)), 
														  (select branch_id from prefers where (app_no = application and pref_rank = top)));
							update offers set unres_alloted = unres_alloted+1 
								where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
										and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)));
							leave loop1;
				else
					set top = top+1;
				end if;
			else
				set top = top+1;
			end if;
		
        # if the reserved seats are filled checks if the unreserved seats are available
        # if yes enter the if statement
		elseif not isnull((SELECT unres_seats 
		            from (select unres_seats 
					from offers 
                    where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
						   and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) A 
			        join
			        (select unres_alloted
				     from offers
                     where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
						    and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) B
			        where A.unres_seats>B.unres_alloted)) then
			
            # checks if the student clears the percentile cutoff
            # enters the if statement if it clears
			if not isnull((select A.percentile from
						(select percentile from student where app_no=application) A 
						join
						(select percentile_cutoff from offers 
						where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
								and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) B
						where A.percentile>=B.percentile_cutoff)) then
                        
				# checks if the student clears the eligibilty of subject cutoffs
                # if clears the eligibility then allots the seats, updates the no of alloted seats and leaves the loop
				if not isnull((select alpha.A from
								(select count(*) as A from sub_cutoff where (
													branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
														and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) alpha
								join
								(select count(*) as B from
											(select * from sub_cutoff where (
													branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
														and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)))) A
											join
											(select * from sub_marks where (app_no = application)) B
											where (A.subject = B.subject and A.marks<=B.marks)) beta
								where alpha.A = beta.B)) then
                                
							insert into allotment values (application, 
														  (select college_id from prefers where (app_no = application and pref_rank = top)), 
														  (select branch_id from prefers where (app_no = application and pref_rank = top)));
							update offers set unres_alloted = unres_alloted+1 
								where (branch_id=(select branch_id from prefers where (app_no = application and pref_rank = top))
										and college_id=(select college_id from prefers where (app_no = application and pref_rank = top)));
							leave loop1;
				else
                    set top = top+1;
				end if;
			else
				set top = top+1;
			end if;
		else
			set top = top+1;
		end if;
	end if;
    end loop loop1;
end $$
delimiter ;

# Call the procedure
call allot(1135);







# Query 5
# ********* To use this query call the allot_all procedure written in Proj_Extra **************
# Drop the procedure if it already exists.
DROP PROCEDURE IF EXISTS alloted_students;
# Creating procedure
delimiter $$
create procedure alloted_students(IN college_no int unsigned, branch_no varchar(5))
begin
select A.app_no as 'Application No.', concat(A.first_name, ' ', A.last_name) as 'Student Name'
	from student A                      # Selecting name and application number from join of student table and subquery 
	join
    (select * from allotment where (college_id = college_no and branch_id=branch_no)) B    # Selecting the rows from allotement table for specific college and branch
    where A.app_no = B.app_no;    # Joining the tables when app_no is same.
end $$
delimiter ;
# Call  the procedure
call alloted_students(113,'cse');





# Query 6
# Drop the procedure if it already exists.
DROP PROCEDURE IF EXISTS delete_student;
# Creating procedure
delimiter $$
create procedure delete_student(IN student_id int unsigned)
begin
delete from student where (app_no = student_id);
end $$
delimiter ;
# Call the procedure
call delete_student(1135);




# Query 7
# Updating the state of the student.
update student set state = 'Haryana' where (app_no = 1234);





# Query 8
# Changing the branch required.
update prefers set branch_id = 'ece' where (pref_rank = 3 and app_no = 1234);




# Query 9
# To change the percentile cutoff
update offers set percentile_cutoff = 93.00 where (college_id = 113);
# To change the subject in subject cutoff
UPDATE sub_cutoff SET subject = 'Mathematics' WHERE (branch_id = 'cse') and (college_id = 113) and (subject = 'Physics');






# Query 10
# Delete the procedure if it already exists
DROP PROCEDURE IF EXISTS application_count;
# creating procedure
delimiter $$
create procedure application_count(IN college_no int unsigned, branch_no varchar(5))
begin
select count(*) as 'No. of Applications'
	from prefers where (college_id=college_no and branch_id=branch_no);
end $$
delimiter ;
call application_count(113,'cse');


# Query 11
# Drop the procedure if already exists
DROP PROCEDURE IF EXISTS filled_seats;
# create procedure
delimiter $$
create procedure filled_seats()
begin
select concat(beta.college_id, ': ', beta.name) as 'College with Filled Seats' from
	(select * from
		(select college_id, sum(unres_seats) as total_unres_seats, sum(res_seats) as total_res_seats, sum(unres_alloted) as total_unres_alloted, sum(res_alloted) as total_res_alloted
			from offers group by college_id) A    # calculating total seats alloted and total seats 
		where (total_unres_seats=total_unres_alloted and total_res_seats=total_res_alloted)) alpha   # selecting those colleges with all filled seats
	join
    college beta
    where alpha.college_id=beta.college_id;
end $$
delimiter ;
# call the procedure
call filled_seats();






# Query 12
# Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS seats_available;
# Create procedure
delimiter $$
create procedure seats_available(IN branch_no varchar(5))
begin
# Sum over the seats that are alloted and intially given. Then these values are subtracted
select sum(res_seats) - sum(res_alloted) as 'Total Available Domicile Reserved Seats', sum(unres_seats) - sum(unres_alloted) as 'Total Available Unreserved Seats', sum(res_seats) + sum(unres_seats) - sum(res_alloted) - sum(unres_alloted) as 'Total Available Seats'
from offers
where branch_id = branch_no;
end $$
delimiter ;
# call the procedure
call seats_available('cse');

