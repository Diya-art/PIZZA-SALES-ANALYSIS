create database loans_dataset_jan;

use loans_dataset_jan;

select * from loans limit 10;

alter table loans_data_csv
add column AppDate DATE;

select * from loans_data_csv;

select Str_To_Date(applicationdate,"yyyy-mm-dd"),AppDate
from loans_data_csv;
select * from loans_data_csv;

update loans_data_csv
set AppDate = Str_to_date(applicationdate,"yyyy-mm-dd");

SET SQL_SAFE_UPDATES = 0;

select date_format(appdate, "%d-%m-%Y")
from loans_data_csv;

create database cc_profil_database;

use cc_profil_database;

show tables;

select annualsalary
from credit_card_profile_data_csv;

select replace(annualsalary, ",","") * 1, 
cast(replace(annualsalary, ",","") as unsigned)
from credit_card_profile_data_csv;

alter table credit_card_profile_data_csv
add column Salary INT;

select salary
from credit_card_profile_data_csv;

alter table credit_card_profile_data_csv
drop column annualsalary;

alter table credit_card_profile_data_csv
rename column `Number of Credit cards` to NoOfCC;

select *
from credit_card_profile_data_csv;

create database students;
 use students;
 
 select *
 from student_blank;
 
 select ID, FullName, DOB,Sex
 from student_blank;
 
 Tasks:
 /*Relace the flagged values with null*/
 /*Convert DOB values from text to date*/
 
 describe student_blank;
 
 update student_blank
 set SEX = NULL, CLass= NULL, HCode= NULL, DCODE = NULL
 where SEX = "T" and CLass= "T" and HCode= "T" and DCODE = "T";
 
 SET SQL_SAFE_UPDATES=0;
 
 update student_blank
 set ptest= NULL
 where ptest=999;
 
 /*since dob column is alrdy in text so we create new column with data type as date and time*/
 /*since time is already 000 so we will EXTRACT the date only, i.e., first 10 characters, for that we use the function left in SQL*/
 /*left(DOB,10)*/
 
 Alter table student_blank
 add column new_DOB DATE;
 
 update student_blank
 SET new_DOB= str_to_date(left(DOB,10),"%d-%m-%Y");
 
 select *
 from student_blank;
 
 