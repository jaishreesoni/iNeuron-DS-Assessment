/*Question 1: Given the following tables:
What will be the result of the query below?
SELECT * FROM runners WHERE id NOT IN (SELECT winner_id FROM races)
Explain your answer and also provide an alternative version of this query that will avoid the issue that it exposes. 
*/
#Solution: 
create database SQLQUESTION;
use SQLQUESTION;
show databases;
CREATE TABLE runners (
    id INT,
    name VARCHAR(255)
);
INSERT INTO runners (id, name) VALUES
(1, 'John Doe'),
(2, 'Jane Doe'),
(3, 'Alice Jones'),
(4, 'Bobby Louis'),
(5, 'Lisa Romero');

select * from runners;

CREATE TABLE races (
    id INT,
    event VARCHAR(255),
    winner_id INT
);

INSERT INTO races (id, event, winner_id) VALUES
(1, '100 meter dash', 2),
(2, '500 meter dash', 3),
(3, 'cross-country',2 ),
(4, 'triathlon', NULL);

SELECT * FROM runners WHERE id NOT IN (SELECT winner_id FROM races);

SELECT * FROM runners
WHERE NOT EXISTS (SELECT 1 FROM races WHERE races.winner_id = runners.id);

/*
-- SELECT * FROM runners WHERE id NOT IN (SELECT winner_id FROM races)
-- The provided query is intended to retrieve all rows from the "runners" table where the "id" does not match any "winner_id" in the "races" table. However, it may encounter issues when the subquery returns a NULL value. If there are NULL values in the "winner_id" column of the "races" table, the entire result of the query might be empty due to the way NOT IN handles NULL values.

-- Explanation:

-- The subquery SELECT winner_id FROM races retrieves a list of all "winner_id" values from the "races" table, including any potential NULL values.
-- The main query then selects all rows from the "runners" table where the "id" is not present in the list obtained from the subquery.
-- The issue arises because NOT IN may not behave as expected when dealing with NULL values in the subquery, potentially leading to unexpected results.
-- To avoid this issue, an alternative version of the query can be used with the NOT EXISTS clause:

*/

/*
Question: 2
Write a query to fetch values in table test_a that are and not in test_b without using the NOT keyword.
*/
#Solution: 
create table test_a(
   id int
);

insert into test_a (id) values
(10),
(20),
(30),
(40),
(50);
select * from test_a;
use ineurontest;

CREATE TABLE test_b (
  id INT
);

insert into test_b (id) values
(10),
(30),
(50);

select * from test_b;

SELECT a.id
FROM test_a a
LEFT JOIN test_b b ON a.id = b.id
WHERE b.id IS NULL;

/*Question 3: 
Write a query to to get the list of users who took the a training lesson more than once in the same day, grouped by user and training lesson, each ordered from the most recent lesson date to oldest date.
*/

#Solution:
 CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL
);

-- Insert data into users table
INSERT INTO users (user_id, username) VALUES
(1, 'John Doe'),
(2, 'Jane Don'),
(3, 'Alice Jones'),
(4, 'Lisa Romero');

select * from users;

CREATE TABLE training_details (
    user_training_id INT PRIMARY KEY,
    user_id INT,
    training_id INT,
    training_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


INSERT INTO training_details (user_training_id, user_id, training_id, training_date) VALUES
(1, 1, 1, '2015-08-02'),
(2, 2, 1, '2015-08-03'),
(3, 2, 2, '2015-08-02'),
(4, 4, 2, '2015-08-04'),
(5, 2, 2, '2015-08-03'),
(6, 1, 1, '2015-08-02'),
(7, 3, 2, '2015-08-04'),
(8, 4, 3, '2015-08-03'),
(9, 1, 4, '2015-08-03'),
(10, 3, 1, '2015-08-02'),
(11, 4, 2, '2015-08-04'),
(12, 3, 2, '2015-08-02'),
(13, 1, 1, '2015-08-02'),
(14, 4, 3, '2015-08-03');

select * from training_details;

SELECT
    u.user_id,
    u.username,
    td.training_id,
    COUNT(*) AS lesson_count,
    MAX(td.training_date) AS most_recent_date,
    MIN(td.training_date) AS oldest_date
FROM
    users u
JOIN
    training_details td ON u.user_id = td.user_id
WHERE
    td.training_id IS NOT NULL
GROUP BY
    u.user_id, u.username, td.training_id, td.training_date
HAVING
    COUNT(*) > 1
ORDER BY
    most_recent_date DESC
LIMIT 0, 50000;





CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Salary INT,
    Manager_Id INT
);

INSERT INTO Employee (Emp_Id, Emp_Name, Salary, Manager_Id) VALUES
(10, 'Anil', 50000, 18),
(11, 'Vikas', 75000, 16),
(12, 'Nisha', 40000, 18),
(13, 'Nidhi', 60000, 17),
(14, 'Priya', 80000, 18),
(15, 'Mohit', 45000, 18),
(16, 'Rajesh', 90000, null),
(17, 'Raman', 55000, 16),
(18, 'Santosh', 65000, 17);

select * from Employee;

-- Query to generate the required output
SELECT
    Manager_Id,
    CASE 
        WHEN Manager_Id = 16 THEN 'Rajesh'
        WHEN Manager_Id = 17 THEN 'Raman'
        WHEN Manager_Id = 18 THEN 'Santosh'
    END AS Manager,
    AVG(Salary) AS Average_Salary_Under_Manager
FROM
    Employee
WHERE
    Manager_Id IS NOT NULL
GROUP BY
    Manager_Id, Manager
ORDER BY
    Manager_Id;