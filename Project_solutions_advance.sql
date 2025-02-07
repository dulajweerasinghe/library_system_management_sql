-- Advanced SQL Operations --
select * FROM books;
select * FROM branch;
select * FROM employees;
select * FROM issued_status;
select * FROM members;
select * FROM return_status;


-- Task 13: Identify Members with Overdue Books --
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, 
-- book title, issue date, and days overdue.--

-- issued_status == members ++ books ==  
-- filter books which is return
-- overdue > 30 days

-- Step 01
SELECT *
	FROM issued_status as ist
	JOIN
	members as m
	ON m.member_id = ist.issued_member_id;
	
-- Step 02
SELECT *
	FROM issued_status as ist
	JOIN
	members as m
	ON m.member_id = ist.issued_member_id
	JOIN books as bk
	ON bk.isbn = ist.issued_book_isbn;

-- Step 03
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

-- Step 04
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

-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

select * FROM books;

-- Step 01

SELECT * FROM issued_status;

select * FROM books
WHERE isbn = '978-0-451-52994-2';

-- Update status
UPDATE books
SET status = 'No'
WHERE isbn = '978-0-451-52994-2';

-- Check in issued status table 
select * FROM issued_status
WHERE issued_book_isbn = '978-0-451-52994-2';

-- Step 02
-- Find it is return or not

select * FROM return_status
WHERE issued_id = 'IS130'

--------------------------------------------------------------------------------------------------------- 

INSERT INTO return_status(return_id, issued_id, return_date, book_quality )
VALUES ('RS125', 'IS130', CURRENT_DATE, 'Good') ;
SELECT * FROM return_status
WHERE issued_id = 'IS130';

-- Update book Table
-- Update status
UPDATE books
SET status = 'Yes'
WHERE isbn = '978-0-451-52994-2';

select * FROM books
WHERE isbn = '978-0-451-52994-2';

-- Store Procedures Template --
Create OR REPLACE PROCEDURES add_return_records()
LANGUAGE plpgsql
AS $$

DECLARE

BEGIN
	-- all your logic and code	
	
END;

CALL add_return_records()

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

----------------------------------------------------------------------------------------

-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, 
-- the number of books returned, and the total revenue generated from book rentals.

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

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

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


-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

-- JOIN Table
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








