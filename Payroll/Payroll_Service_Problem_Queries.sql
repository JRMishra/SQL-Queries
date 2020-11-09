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

update p
set p.deptId = d.id
from Department d inner join employee_payroll p on d.name = p.department
;

select * from employee_payroll;

create procedure SpAddEmployeeDetails
(
@EmployeeName varchar(255),
@PhoneNumber varchar(255),
@Address varchar(255),
@Department varchar(255),
@Gender char(1),
@BasicPay float,
@Deductions float,
@TaxablePay float,
@Tax float,
@NetPay float,
@StartDate Date
)
as
begin
insert into employee_payroll values
(
@EmployeeName,@BasicPay,@StartDate,@Gender,@PhoneNumber,@Address,@Department,@Deductions,@TaxablePay,@Tax,@NetPay
)
end
