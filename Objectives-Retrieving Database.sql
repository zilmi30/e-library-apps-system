--1.	Determine top 5 books most frequently borrowed by users.
SELECT 
    b.Title, 
    COUNT(br.Book_id) AS Borrow_Count
FROM 
    Borrow br
JOIN 
    Books b ON br.Book_id = b.Book_id
GROUP BY 
    br.Book_id, b.Title
ORDER BY 
    Borrow_Count desc
LIMIT 5;

-- 2.	Identify which libraries are the most visited.
SELECT
    l.Name AS Library_Name,
    COUNT(b.Borrow_id) AS Borrow_Count
FROM
    Borrow b
JOIN
    Libraries l ON b.Library_id = l.Library_id
GROUP BY
    l.Name
ORDER BY
    Borrow_Count desc;

--3.	List books that have been placed on hold in the hold table.
SELECT
    b.Title,
    COUNT(h.Hold_id) AS Hold_Count
FROM
    Hold h
JOIN
    Books b ON h.Book_id = b.Book_id
GROUP BY
    h.Book_id, b.Title
ORDER BY
    Hold_Count desc;

 --4.	Identify users who have borrowed books and the total number of books borrowed. Limit it to five users, order by highest total number of books borrowed
SELECT
    u.User_id,
    u.Name AS User_Name,
    COUNT(b.Borrow_id) AS Total_Borrows
FROM
    Users u
JOIN
    Borrow b ON u.User_id = b.User_id
GROUP BY
    u.User_id, u.Name
ORDER BY
    Total_Borrows desc
LIMIT 5;

--5.	Analyze the duration between borrowing and returning books from the borrow table and compare it with the average borrowing duration. Limit it to 10 users
WITH avg_borrow_return_days AS (
    SELECT AVG(r.return_date - br.borrow_date) AS avg_duration_days
    FROM borrow br
    JOIN "return" r ON br.borrow_id = r.borrow_id
)

SELECT 
    br.borrow_id,
    r.return_id,
    br.book_id,
    br.library_id,
    br.borrow_date,
    r.return_date,
    r.return_date - br.borrow_date AS time_delta,
    abrd.avg_duration_days
FROM 
    borrow br
JOIN 
    "return" r ON br.borrow_id = r.borrow_id
CROSS JOIN 
    avg_borrow_return_days abrd
LIMIT 10;


   