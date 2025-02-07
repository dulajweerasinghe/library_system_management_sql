# Library Management System (SQL Database)

## Overview
This project is a **Library Management System** implemented using SQL. It includes tables for managing branches, employees, books, and members, along with necessary constraints and relationships.

## Database Schema
The database consists of the following tables:

### Branch Table
```sql
CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(55),
    contact_no VARCHAR(20)
);
```

### Employees Table
```sql
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(25),
    position VARCHAR(20),
    salary INT,
    branch_id VARCHAR(25)
);
```

### Books Table
```sql
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(75),
    category VARCHAR(20),
    rental_price FLOAT,
    status VARCHAR(15),
    author VARCHAR(35),
    publisher VARCHAR(55)
);
```

### Members Table
```sql
CREATE TABLE members (
    member_id VARCHAR(15) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(75),
    reg_date DATE
);
```

## Setup Instructions
To set up the database, follow these steps:

1. Ensure you have a SQL database system like MySQL or PostgreSQL installed.
2. Open your SQL command line tool or database management software.
3. Run the SQL script file:
   ```sql
   SOURCE library_project.sql;
   ```
   ```sql
   SOURCE Project_solutions_advance.sql;
   ```

## Project Solutions
This repository also includes a **Project Solutions** SQL script that contains example queries for performing various operations on the database. It includes solutions for tasks such as:
- Inserting new book records
- Updating member details
- Deleting records from tables
- Retrieving specific data from the database

To run the solutions file:
```sql
SOURCE Project_solutions.sql;
```

## SQL Task Questions and Answers
Below are the SQL queries solving various tasks related to the library management system:

#### Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```

#### Task 2: Update an Existing Member's Address
```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C101';
```

#### Task 3: Delete a Record from the Issued Status Table
##### Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';

select * FROM issued_status
WHERE   issued_id =   'IS121';
```

#### Task 4: Retrieve All Books Issued by a Specific Employee
##### Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```

#### Task 5: List Members Who Have Issued More Than One Book 
##### Objective: Use GROUP BY to find members who have issued more than one book.
```sql
SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1
```

#### Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
#### CTAS (Create Table As Select)
```sql
-- Step 01

select * 
FROM books as b
JOIN 
	issued_status as ist
	ON ist.issued_book_isbn = b.isbn

-- Step 02
select b.isbn,
		b.book_title,
	count(ist.issued_id) as no_issued
FROM books as b
JOIN 
	issued_status as ist
	ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2

-- Step 03

CREATE TABLE book_cnts 
	as
	select b.isbn,
		b.book_title,
	count(ist.issued_id) as no_issued
FROM books as b
JOIN 
	issued_status as ist
	ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2

-- Final Step

select * FROM book_cnts;

```
#### Task 7. Retrieve All Books in a Specific Category:
```sql
SELECT * FROM books
WHERE category = 'Classic';
```
#### Task 8: Find Total Rental Income by Category:
```sql
SELECT
	b.category,
	SUM(b.rental_price),
	COUNT(*)
FROM
issued_status as ist
Join books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;
```
#### Task 09 List Members Who Registered in the Last 180 Days:
```sql
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
	('C120', 'Dulaj', '145 Main St', '2024-12-01'),
	('C121', 'Lakshan', '133 Main St', '2024-12-04');

-- Last 180 Days
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

#### Task 10. List Employees with Their Branch Manager's Name and their branch details:
```sql
select * FROM branch;
select * FROM employees;
-- STEP 01
select *
FROM employees as e1
	join 
	branch as b
	ON b.branch_id = e1.branch_id
	JOIN
	employees as e2
	ON b.manager_id = e2.emp_id;

-- STEP 02

select e1.*,
	   b.manager_id,
	   e2.emp_name as manager
FROM employees as e1
	join 
	branch as b
	ON b.branch_id = e1.branch_id
	JOIN
	employees as e2
	ON b.manager_id = e2.emp_id;
```
#### Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
```sql
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

select * FROM expensive_books;
```
#### Task 12: Retrieve the List of Books Not Yet Returned
```sql
SELECT * FROM issued_status;

--STEP 01

SELECT *
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id;

-- Step 02

SELECT 
	DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;;
```

## SQL Task Advance Questions and Answers
Below are the SQL queries solving various tasks related to the library management system:

#### Task 13: Identify Members with Overdue Books
##### Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, 
##### book title, issue date, and days overdue.
###### issued_status == members ++ books ==  
###### filter books which is return
###### overdue > 30 days


```sql
-- Step 
SELECT *
	FROM issued_status as ist
	JOIN
	members as m
	ON m.member_id = ist.issued_member_id
	JOIN books as bk
	ON bk.isbn = ist.issued_book_isbn
	LEFT JOIN
	return_status as rs
	ON rs.issued_id = ist.issued_id;

-- Step 
SELECT ist.issued_member_id,
	   m.member_name,
	   bk.book_title,
	   ist.issued_date,
	   rs.return_date
	FROM issued_status as ist
	JOIN
	members as m
	ON m.member_id = ist.issued_member_id
	JOIN books as bk
	ON bk.isbn = ist.issued_book_isbn
	LEFT JOIN
	return_status as rs
	ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL;

-- Step FINAL
SELECT ist.issued_member_id,
	   m.member_name,
	   bk.book_title,
	   ist.issued_date,
	   CURRENT_DATE - ist.issued_date as over_due_days
	FROM issued_status as ist
	JOIN
	members as m
	ON m.member_id = ist.issued_member_id
	JOIN books as bk
	ON bk.isbn = ist.issued_book_isbn
	LEFT JOIN
	return_status as rs
	ON rs.issued_id = ist.issued_id
WHERE 
	rs.return_date IS NULL
	and
	(CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;
```
#### Task 14: Update Book Status on Return
##### Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
```sql
-- Create Final Code --  

CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR(10), 
    p_issued_id VARCHAR(10), 
    p_book_quality VARCHAR(15)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(100); -- Each variable must be declared on a separate line
BEGIN
    -- Insert return record
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);    

    -- Retrieve ISBN and book title from issued_status
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;  -- Fixed the condition

    -- Update book status in books table
    UPDATE books
    SET status = 'Yes'
    WHERE isbn = v_isbn;

    -- Display message
    RAISE NOTICE 'Thank you for returning the Book: %', v_book_name;
END;
$$;

CALL add_return_records()

------------------------------------------------------------------------------------
-- Testing FUNCTION add Return records

select * FROM books
WHERE isbn = '978-0-307-58837-1';

select * FROM issued_status
where issued_id = 'IS135';

select * FROM return_status
where issued_id = 'IS135';

-- Test 01 --

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1';

select * FROM books
WHERE isbn = '978-0-307-58837-1';

-- Check
select * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

select * FROM return_status
where issued_id = 'IS135';

-- Update DATA and Check 

CALL add_return_records('RS138', 'IS135', 'Good');

-------------------------------------------------------------------------------------
-- Test 02 Another Book(issued_id=IS140) --

select * FROM books
WHERE isbn = '978-0-330-25864-8';

--Change update status to 'No'--
UPDATE books
SET status = 'No'
WHERE isbn = '978-0-330-25864-8';

-- Check issued status
select * FROM issued_status
WHERE issued_book_isbn = '978-0-330-25864-8';

-- Update DATA and Check 

CALL add_return_records('RS148', 'IS140', 'Good');
```
#### Task 15: Branch Performance Report
##### Create a query that generates a performance report for each branch, showing the number of books issued,
##### the number of books returned, and the total revenue generated from book rentals.
```sql
-- Join All this tables

select * FROM branch

SELECT * FROM issued_status;

SELECT * FROM employees;

SELECT * FROM books;

SELECT * FROM return_status;

-- Step 01

SELECT 
		b.branch_id,
		b.manager_id,
		COUNT(ist.issued_id) as number_book_issued,
		COUNT(rs.return_id) as number_of_book_return,
		SUM(bk.rental_price) as total_revenue
	FROM issued_status as ist
	JOIN 
	employees as e
	ON e.emp_id = ist.issued_emp_id
	JOIN
	branch as b
	ON e.branch_id = b.branch_id
	LEFT JOIN
	return_status as rs
	ON rs.issued_id = ist.issued_id
	JOIN
	books as bk
	ON ist.issued_book_isbn = bk.isbn
GROUP BY 1,2

-- Create Table --

CREATE TABLE branch_reports
AS
SELECT 
		b.branch_id,
		b.manager_id,
		COUNT(ist.issued_id) as number_book_issued,
		COUNT(rs.return_id) as number_of_book_return,
		SUM(bk.rental_price) as total_revenue
	FROM issued_status as ist
	JOIN 
	employees as e
	ON e.emp_id = ist.issued_emp_id
	JOIN
	branch as b
	ON e.branch_id = b.branch_id
	LEFT JOIN
	return_status as rs
	ON rs.issued_id = ist.issued_id
	JOIN
	books as bk
	ON ist.issued_book_isbn = bk.isbn
GROUP BY 1,2

-- Check Branch Report

select * from branch_reports;
```
#### Task 16: CTAS: Create a Table of Active Members
##### Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
```sql
SELECT * FROM issued_status;

-- STEP 01

SELECT 
	*,
	issued_member_id
FROM issued_status
WHERE 
		issued_date >= CURRENT_DATE - INTERVAL '2 Month';

-- Step 02

SELECT 
	DISTINCT issued_member_id
FROM issued_status
WHERE 
		issued_date >= CURRENT_DATE - INTERVAL '2 Month';

-- Write a subquery

select * from members
	where member_id IN (SELECT 
						DISTINCT issued_member_id
					FROM issued_status
				WHERE 
					issued_date >= CURRENT_DATE - INTERVAL '2 Month')

-- Create Table ---

CREATE TABLE active_members
	as
select * from members
	where member_id IN (SELECT 
						DISTINCT issued_member_id
					FROM issued_status
				WHERE 
					issued_date >= CURRENT_DATE - INTERVAL '2 Month');

select * from active_members;
```

#### Task 17: Find Employees with the Most Book Issues Processed
##### Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
```sql
JOIN Table
	select * 
	from issued_status as ist
	join 
	employees as e
	ON e.emp_id = ist.issued_emp_id
	join
	branch as b
	ON e.branch_id = b.branch_id

-- Summerize the JOIN Table
	select 
		e.emp_name,
		b.*,
		COUNT(ist.issued_id) as no_book_issued 
	from issued_status as ist
	join 
	employees as e
	ON e.emp_id = ist.issued_emp_id
	join
	branch as b
	ON e.branch_id = b.branch_id
GROUP BY 1,2

```
## Usage
Once the database is set up, you can perform the following actions:
- Insert, update, or delete records in each table.
- Query book availability.
- Track employee and member details.
- Execute pre-defined solutions from `Project_solutions.sql`.

## Contribution
Feel free to fork this repository and submit pull requests for improvements.

## License
This project is open-source and available under the MIT License.

