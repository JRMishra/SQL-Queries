--UC1_Create-AddressBook-Service-Database
CREATE DATABASE addressbook_service;


--UC2_Create-AddressBook-Table
USE addressbook_service;

CREATE TABLE address_book
(
id int identity(1,1),
firstname varchar(25) not null,
lastname varchar(20) not null,
address varchar(50) not null,
city varchar(20) not null,
state varchar(20) not null,
zip char(6) not null,
phone_number varchar(15) not null,
email varchar(40) not null
);


--UC3_Insert-New-Contacts
INSERT INTO address_book values
('Bapun','Karmakar','W No 14, Tulasichoura','Baripada','Odisha','757001','+91 2319804235','karmakarb@mymail.com'),
('Subham','Sahu','MNH colony,KV Circle','Balasore','Odisha','757141','+91 0423521098','sahu.subham@mymail.com'),
('Suchi','Kaur','Near DAV School','Bubhaneswar','Odisha','757652','+91 6723500123','ksuchi01@mymail.com'),
('Simran','Dasgupta','Near junction road','Durgapur','WestBengal','812391','+91 9980176528','dassimrangupta@mymail.com');


--UC4_Edit-Existing-Contact-Details
UPDATE address_book
SET zip = '577141' where firstname = 'Subham';

--UC5_Delete-Person-Using_Name
DELETE FROM address_book
WHERE firstname = 'Suchi';

SELECT * FROM address_book;

--UC6_Retrieve-Person-From-A-State-Or-City
SELECT * FROM address_book
WHERE city = 'Balasore';

SELECT * FROM address_book
WHERE state = 'Odisha';

--UC7_Size-By-City-Or-State
SELECT city, COUNT(id) from address_book
GROUP BY city;

SELECT state, COUNT(id) from address_book
GROUP BY state;

--UC8_Entries-Sorted-Alphabetically
SELECT * FROM address_book
WHERE state = 'Odisha'
ORDER BY firstname;

--UC9_Alter-addressbook-to-add-new-column
ALTER TABLE address_book
ADD bookname nvarchar(15);

ALTER TABLE address_book
ADD contacttype nvarchar(10);

UPDATE address_book
SET bookname = 'General',
    contacttype = 'Family'
WHERE id in (1,2);

UPDATE address_book
SET bookname = 'General',
	contacttype = 'Friend'
WHERE id = 4;

select * from address_book;

--UC10_Count-By-Type
SELECT contacttype, COUNT(id) as NumberOfContacts
from address_book
GROUP BY contacttype;

--UC11_Add-Person-To-Friend-And-Family
INSERT INTO address_book values
('Satyam','Mishra','NML Colony','Ranchi','Odisha','870601','+91 7612303461','mishrasatyam@mymail.com','General','Family'),
('Satyam','Mishra','NML Colony','Ranchi','Odisha','870601','+91 7612303461','mishrasatyam@mymail.com','General','Friend')
;
select * from address_book;

--UC13_Retstructure tables
CREATE TABLE address_details
(
zip varchar(15) not null primary key,
address varchar(50) not null,
city varchar(20) not null,
state varchar(15) not null,
country varchar(10) default 'India'
);

select * from address_details;

INSERT INTO address_details (address,city,state,zip)
values ('W No 14, Tulasichoura','Baripada','Odisha','757001'),
('MNH colony,KV Circle','Balasore','Odisha','757141'),
('Near DAV School','Bubhaneswar','Odisha','757652'),
('Near junction road','Durgapur','WestBengal','812391');

alter table address_book
drop column address,city,state;

select * from address_book;

CREATE TABLE book_info
(
id int identity(1,1),
name varchar(20) not null default 'General',
type varchar(50) not null,
primary key (name,type)
);

select* from book_info;

INSERT INTO book_info(type)
values ('Family'),
('Friend'),
('Office');

INSERT INTO book_info(type) values ('Family'); --will not execute

alter table address_book add bookid int;

UPDATE address_book
SET bookid = 1
WHERE id in (1,2,5);

UPDATE address_book
SET bookid = 2
WHERE bookname = 'General'
and contacttype = 'Friend';

select * from address_book;

alter table address_book
drop column bookname, contacttype;

select a.id, a.firstname,a.lastname,d.city,d.state,a.zip,d.zip from address_book a
join address_details d on d.zip=a.zip
; 