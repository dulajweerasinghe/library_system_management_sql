-- 10 Tasks Answers

select * FROM return_status;
select * FROM books;
select * FROM branch;
select * FROM employees;
select * FROM issued_status;
select * FROM members;

-- Solve the Problems
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

select * FROM issued_status;

DELETE FROM issued_status
WHERE   issued_id =   'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
--- CTAS (Create Table As Select)

select * FROM books;

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

-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:

SELECT
	b.category,
	SUM(b.rental_price),
	COUNT(*)
FROM
issued_status as ist
Join books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;

-- Task 09 List Members Who Registered in the Last 180 Days:
-- Add New Data 
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
	('C120', 'Dulaj', '145 Main St', '2024-12-01'),
	('C121', 'Lakshan', '133 Main St', '2024-12-04');

-- Last 180 Days
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Task 10. List Employees with Their Branch Manager's Name and their branch details:

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

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

select * FROM expensive_books;

-- Task 12: Retrieve the List of Books Not Yet Returned

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
WHERE rs.return_id IS NULL;










