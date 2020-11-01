--UC1_Create-Payroll-Service-Database
create database payroll_service;


--UC2_Create-Employee-Payroll-Table
use payroll_service;

create table employee_payroll
(
id int identity(1,1),
name varchar(25) not null,
salary money not null,
start date not null
);


--UC3_Insert-Employee-Payroll-Data
insert into employee_payroll values
('Bapun',100000.00,'2019-10-01'),
('Subham',120000.00,'2020-05-15'),
('Suchi',120000.00,'2020-05-01'),
('Simran',90000.00,'2019-12-01');


--UC4_Retrieve-All-Payroll-Data
select * from employee_payroll;


--UC5_Retrieve-Data-Using-Conditions
select * from employee_payroll
where name = 'Subham';

select * from employee_payroll
where start between '2020-01-01' and GETDATE();


--UC6_Add-New-Column-&-Update-Existing_Rows
ALTER TABLE employee_payroll
ADD gender char;

select * from employee_payroll;

UPDATE employee_payroll
SET gender = 'M'
where id in (1,2);

UPDATE employee_payroll
SET gender = 'F'
where id in (3,4);


--UC7_Use-DB-Functions
SELECT gender, SUM(salary) FROM employee_payroll
GROUP BY gender;

SELECT gender, MAX(salary) FROM employee_payroll
GROUP BY gender;

SELECT gender, MIN(salary) FROM employee_payroll
GROUP BY gender;

SELECT gender, AVG(salary) FROM employee_payroll
GROUP BY gender;

SELECT gender, COUNT(id) FROM employee_payroll
GROUP BY gender;