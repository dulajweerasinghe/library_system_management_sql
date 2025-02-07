-- Library Management System Project 

-- Create Branch Table

DROP TABLE IF EXISTS branch;
create table branch (
		branch_id VARCHAR(10) PRIMARY KEY, 
		manager_id VARCHAR(10),
		branch_address VARCHAR (55), 
		contact_no VARCHAR(10)
	);
ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(20);


-- Create Employees Table

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(25),
	position VARCHAR(20),	
	salary INT,	
	branch_id VARCHAR(25) -- fk
	);

-- Create Books Table

DROP TABLE IF EXISTS books;
CREATE TABLE books (
	isbn VARCHAR(20) primary key,	
	book_title VARCHAR(75),	
	category VARCHAR(10),	
	rental_price FLOAT,
	status VARCHAR(15),	
	author VARCHAR(35),	
	publisher VARCHAR(55)
	);

ALTER TABLE books
ALTER COLUMN category TYPE VARCHAR(20);

-- Create members table

DROP TABLE IF EXISTS members;
CREATE TABLE members (
	member_id VARCHAR(15) primary key,
	member_name VARCHAR(25),
	member_address VARCHAR(75),
	reg_date date
	);

-- Create issued status table

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
		issued_id VARCHAR(15) primary key,
		issued_member_id VARCHAR(10), -- fk
		issued_book_name VARCHAR(75),	
		issued_date date,
		issued_book_isbn VARCHAR(25), --fk
		issued_emp_id VARCHAR(10) -- fk
	);
ALTER TABLE issued_status ALTER COLUMN issued_id TYPE VARCHAR(20);
-- Create Return Status Table

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
		return_id VARCHAR(10) primary key,
		issued_id VARCHAR(10),
		return_book_name VARCHAR(75),
		return_date date,
		return_book_isbn VARCHAR(20)
		);

-- FOREIGN KEY

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

SELECT * FROM pg_stat_activity;

select * FROM return_status;
select * FROM books;
select * FROM branch;
select * FROM employees;
select * FROM issued_status;
select * FROM members;




