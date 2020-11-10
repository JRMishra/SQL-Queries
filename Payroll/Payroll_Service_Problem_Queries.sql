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

--UC8_Extend-EmpPayroll-Data
alter table employee_payroll add phone varchar(15);

alter table employee_payroll add department varchar(25) not null default 'General';

alter table employee_payroll add address varchar(50);

alter table employee_payroll add constraint default_address default 'India' for address;

insert into employee_payroll (name,basic_pay,start)
values ('Satyam',105000.00,'2019-05-01');

select * from employee_payroll;

--UC9_Extend-To-Add-Various-Pay
sp_rename 'employee_payroll.salary','basic_pay';

alter table employee_payroll add deduction money,
taxable_pay money, net_pay money, incomeTax real;

--UC10_One-Person-In-Different-Dept
insert into employee_payroll (name,basic_pay,start,department)
values ('Satyam',105000.00,'2019-05-01','Sales'),
('Satyam',105000.00,'2019-05-01','Marketing')
;

select * from employee_payroll;

--UC11_Impliment-New-ER-Structure
alter table employee_payroll add deptId int;

--Create new Department table
CREATE TABLE Department
(
id int identity(1,1),
name varchar(20) primary key
);

INSERT INTO Department
values ('Finance'),('Sales'),('HR'),('IT'),('Production')
;
INSERT INTO Department
values ('Marketing')
;

update employee_payroll
set department = 'Production'
where department = 'General'
;

--update deptId in employee_payroll
update p
set p.deptId = d.id
from Department d inner join employee_payroll p on d.name = p.department
;

--delete department column in employee_payroll
alter table employee_payroll
drop column department;

--Create new Payroll table
CREATE TABLE Payroll
(
basic_pay money primary key,
deduction money not null,
taxable_pay money not null,
income_tax money not null,
net_pay money not null
);

--Store procedure to fill payroll table
alter procedure spFillPayroll
(
@basic_pay money
)
as
DECLARE	@count int
begin
select @count = count(basic_pay) from Payroll
where basic_pay = @basic_pay
end
if(@count=0)
begin
insert into Payroll values
(
@basic_pay,@basic_pay*0.2,@basic_pay*0.8,@basic_pay*0.08,@basic_pay*0.92
)
end

--Execute store procedure
exec spFillPayroll @basic_pay = 100000;
select * from Payroll;
exec spFillPayroll @basic_pay = 115000;

--drop payroll columns
alter table employee_payroll
drop column deduction, taxable_pay, net_pay, incomeTax;

--Store procedure to count dept
alter procedure spCountDept
( @deptname nvarchar(25))
as
DECLARE	@count int
begin
select @count = count(id) from Department
where name = @deptname
end
if(@count=0)
begin
insert into Department values
(
@deptname
)
end
;

EXEC spCountDept @deptname = N'Acquisition'
		;
SELECT	* from Department;

-- Store procedure to add employee details
alter procedure SpAddEmployeeDetails
(
@EmployeeName varchar(255),
@PhoneNumber varchar(255),
@Address varchar(255),
@Gender char(1),
@BasicPay money,
@StartDate Date,
@Department varchar(20)
)
as
begin
EXEC [dbo].[spCountDept] @deptname = @Department
end
begin
declare @DeptId int
select @DeptId = id from Department where name = @Department
end
begin
exec spFillPayroll @basic_pay = @BasicPay;
end
begin
insert into employee_payroll values
(
@EmployeeName,@BasicPay,@StartDate,@Gender,@PhoneNumber,@Address,@DeptId
)
end
;


select * from employee_payroll;
select * from Department;
select * from Payroll;

exec SpAddEmployeeDetails  @EmployeeName = 'Sonali',@BasicPay= 90000,@StartDate= '2020-07-15',@Gender='F',
@PhoneNumber = '7710176152', @Address = 'Bhubaneswar', @Department = 'Sales'
;
