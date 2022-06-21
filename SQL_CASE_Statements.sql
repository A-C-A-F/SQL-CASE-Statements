###############################################################
###############################################################
-- Project: SQL CASE Statements
###############################################################
###############################################################

-- Personal Note: I used employees_ser5 database for this on my local machine.

#############################
-- Task One: The SQL CASE Statement
-- In this task, we will learn how to write a conditional
-- statement using a single CASE clause
#############################


-- 1.1: Retrieve all the data in the employees table
SELECT * FROM employees;

-- 1.2: Change M to Male and F to Female in the employees table
SELECT emp_no, first_name, last_name,
CASE
	WHEN gender = 'M' THEN 'Male'
	ELSE 'Female'
END
FROM employees;

-- 1.3: This gives the same result as 1.2 but the column for 'case' will be replaced with 'gender'
SELECT emp_no, first_name, last_name,
CASE
	WHEN gender = 'M' THEN 'Male'
	ELSE 'Female'
END AS gender
FROM employees;

-- 1.4: This gives the same result as 1.2 & 1.3 but this time the 'gender' column is placed after the command CASE.
SELECT emp_no, first_name, last_name,
CASE gender
	WHEN 'M' THEN 'Male'
	ELSE 'Female'
END AS gender
FROM employees;


#############################
-- Task Two: Adding multiple conditions to a CASE statement
-- In this task, we will learn how to add multiple conditions to a 
-- CASE statement
#############################

-- 2.1: Retrieve all the data in the customers table
SELECT * FROM customers;

-- 2.2: Create a column called Age_Category that returns Young for ages less than 30,
-- Aged for ages greater than 60, and Middle Aged otherwise
SELECT *,
CASE
	WHEN age < 30 THEN 'Young'
	WHEN age > 60 THEN 'Aged'
	ELSE 'Middle Aged'
END AS Age_Category
FROM customers;
/* This will create a column age_category in the table fulfill the CASE statement there.*/

-- Let's return the age column ang the newly created column only.
SELECT age,
CASE
	WHEN age < 30 THEN 'Young'
	WHEN age > 60 THEN 'Aged'
	ELSE 'Middle Aged'
END AS Age_Category
FROM customers;


-- 2.3: Retrieve a list of employees that were employed before 1990, between 1990 and 1995, and 
-- after 1995
-- let's check our table again
SELECT * FROM employees

-- let's perform the query
SELECT emp_no, hire_date, EXTRACT(YEAR FROM hire_date) AS Year, /* EXTRACT function is a date-time function.*/
CASE
	WHEN EXTRACT(YEAR FROM hire_date) < '1990' THEN 'Employed before 1990'
	WHEN EXTRACT(YEAR FROM hire_date) >= '1990' AND EXTRACT(YEAR FROM hire_date) <= '1995' 
	THEN 'Employed between 1990 and 1995'
	ELSE 'Employed After 1995'
END AS emp_date
FROM employees;


#############################
-- Task Three: The CASE Statement and Aggregate Functions
-- In this task, we will see how to use the CASE clause and
-- SQL aggregate functions to retrieve data
#############################

/* In this task, we will use the CASE clause and the SQL aggregate functions to retrieve data.
Remember that aggregate functions are applied on multiple rows of a single column of a table and 
returns an output of a single value. This means that they gather data from many rows of a table,
then aggregate or summarize it into a single value.

There are five aggregate functions in SQL. These are COUNT, SUM, MIN, MAX, and average represented by AVG. 
As the names implies, COUNT retrieves the number of not null or not missing records in the field of a table. 
SUM retrieves the sum of all not null or not missing values in the field of a table. 
MIN retrieves the minimum value from a list. 
MAX is the opposite of MIN. It retrieves the maximum value from a list. 
On the other hand, AVG calculates the average of all not null values belonging to a particular column of a table. */


-- 3.1: Retrieve the average salary of all employees
-- let's check the salaries table
SELECT * FROM salaries;

-- let's perform the query
SELECT emp_no, AVG(salary)
FROM salaries
GROUP BY emp_no /* It is important to GROUP BY when you have aggregate functions. */
ORDER BY AVG(salary) DESC;
/* This will return a table of emplyee number and their average salary.
NOTE: It's important to add the GROUP BY because the GROUP BY helps to summarize
for the different records. When working in SQL, results can be grouped by a specific
field or fields.*/


-- 3.2: Retrieve a list of the average salary of employees. If the average salary is more than
-- 80000, return Paid Well. If the average salary is less than 80000, return Underpaid,
-- otherwise, return Unpaid
SELECT emp_no, ROUND(AVG(salary), 2) AS avg_salary,
CASE
	WHEN AVG(salary) > 80000 THEN 'Paid Well'
	WHEN AVG(salary) < 80000 THEN 'Underpaid'
	ELSE 'Unpaid'
END AS salary_category
FROM salaries
GROUP BY emp_no
ORDER BY AVG(salary) DESC;


-- 3.3: Retrieve a list of the average salary of employees. If the average salary is more than
-- 80000 but less than 100000, return Paid Well. If the average salary is less than 80000, 
-- return Underpaid, otherwise, return Manager
SELECT emp_no, ROUND(AVG(salary), 2) AS avg_salary,
CASE
	WHEN AVG(salary) > 80000 AND AVG(salary) < 100000 THEN 'Paid Well'
	WHEN AVG(salary) < 80000 THEN 'Underpaid'
	ELSE 'Manager'
END AS salary_category
FROM salaries
GROUP BY emp_no
ORDER BY AVG(salary) DESC;


-- 3.4: Count the number of employees in each salary category
SELECT a.salary_category, COUNT(*)
FROM (
SELECT emp_no, ROUND(AVG(salary), 2) AS avg_salary,
CASE
	WHEN AVG(salary) > 80000 AND AVG(salary) < 100000 THEN 'Paid Well'
	WHEN AVG(salary) < 80000 THEN 'Underpaid'
	ELSE 'Manager'
END AS salary_category
FROM salaries
GROUP BY emp_no
ORDER BY AVG(salary) DESC
) a
GROUP BY a.salary_category;
/* This will return an aggregated table of salary_category.
In the above code, we used a sub-query and used the query inside it as our source of data.*/

#############################
-- Task Four: The CASE Statement and SQL Joins
-- -- In this task, we will see how to use the CASE clause and
-- SQL Joins to retrieve data
#############################

/* In this task, we will use the CASE clause, and SQL joins to retrieve data. 
Joins is a SQL tool that allows us to construct a relationship between objects like tables.
A join shows a result set containing fields derived from two or more tables.
The SQL Join clause is used to combine records from two or more tables in a database.
A join is a means for combining fields from two tables by using values common to each of these tables.
We must find the related column from the two tables that contain the same type of data.

For example, say we have the employees table and the salaries table in the employees database. 
If we wish to get the first name, last name and salary of employees, given that the first name and 
the last name are in the employees table, and the employee's salary is in the salaries table.
To get these details from these two tables, we have to apply a type of join.

One important thing to note is that we can only apply join to these two tables on their related column.
For example, the employees table can be joined to the salaries table using the employees number column because 
this column exists between these tables. And it's unique.

Lastly, there are four basic types of join: INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN.
We will use the INNER JOIN, and LEFT JOIN in this project. */


-- 4.1: Retrieve all the data from the employees and dept_manager tables
SELECT * FROM employees
ORDER BY emp_no DESC;

SELECT * FROM dept_manager;
/* If we check the 'Messages' tab, it says 24 rows affected.
This means that there are 24 managers in this department
managers table and in the employees database. */

-- 4.2: Join all the records in the employees table to the dept_manager table
/* Basically, what LEFT JOIN does is, it joins two tables,
by returning all the records on the left table, in this case, the employees table.
And only where there is a matching record with the right table, in this case, the department
managers table. So, it will return null if the left table does not have a matching record with the right
table. */
SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name
FROM employees e
LEFT JOIN dept_manager dm
ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no;
/* Since we said there are 24 managers in the dept_manager table, we will see after 24th row in this generated table,
we get null values. That is because it does not find any matching record with the right table.
So, in this case, the order of the table really matters. The employees table here is the left table.
It retrieves every detail, every record from the employees table and joins it to only where it matches 
with the department managers table. And that's why the only part where we have the employee
number returned is where number 24. Because we have both managers in the department managers table and 
in the employees table. But where we didn't have any record that matches with the
department managers table, we'll have null value there. */

/* Let's try again. But this time we want to retrieve the same thing we have as
above, but now where the employee number is greater than 109990. 
Just like what we have in the query above, we're also using LEFT JOIN. */
	
-- 4.3: Join all the records in the employees table to the dept_manager table
-- where the employee number is greater than 109990
SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name
FROM employees e
LEFT JOIN dept_manager dm 
ON dm.emp_no = e.emp_no
WHERE e.emp_no > 109990;
/* This returns 25 rows of information. 
Remembber that for dept_manager table, we have 24 records which are
for the managers. In our new table here there is one more employee located in the 25th of the rows. 
But that employees not a manager, and that's why this employee number here is null. */

-- 4.4: Obtain a result set containing the employee number, first name, and last name
-- of all employees. Create a 4th column in the query, indicating whether this 
-- employee is also a manager, according to the data in the
-- dept_manager table, or a regular employee
SELECT e.emp_no, e.first_name, e.last_name,
CASE
	WHEN dm.emp_no IS NOT NULL THEN 'Manager'
	ELSE 'Employee'
END AS is_manager
FROM employees e
LEFT JOIN dept_manager dm
ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no;
/* After running the query above, Okay, after 24th row of our new table, 
all other ones should be labeled as Employees.*/

-- 4.5: Obtain a result set containing the employee number, first name, and last name
-- of all employees with a number greater than '109990'. Create a 4th column in the query,
-- indicating whether this employee is also a manager, according to the data in the
-- dept_manager table, or a regular employee
SELECT e.emp_no, e.first_name, e.last_name,
CASE
	WHEN dm.emp_no IS NOT NULL THEN 'Manager'
	ELSE 'Employee'
END AS is_manager
FROM employees e
LEFT JOIN dept_manager dm
ON dm.emp_no = e.emp_no
WHERE e.emp_no > 109990
ORDER BY dm.emp_no;
/* Whe we run the query earlier in 4.3, it returned 25 records.
All thr manager was retrieved but there was one employee captured which is not a manager.
After running the query above, we should still get 25 records. But this time, they are properly labeled
in the 'is_manager' column.*/

#############################
-- Task Five: The CASE Statement together with Aggregate Functions and Joins
-- In this task, we will see how to use the CASE clause together with
-- SQL aggregate functions and SQL Joins to retrieve data
#############################

-- 5.1: Retrieve all the data from the employees and salaries tables
SELECT * FROM employees;

SELECT * FROM salaries;

-- 5.2: Retrieve a list of all salaries earned by an employee
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no;
/* The JOIN here means INNER JOIN. We can use JOIN or INNER JOIN.
This type of join returns those records which have matching values in both tables. 
Unlike LEFT JOIN that returns only where there is a matching value with the left table, 
and where there a matching value with right table and returns null where there is no matching value,
the INNER JOIN or JOIN works more like intersection of two sets.

So, if we perform an INNER JOIN operation between the employees table and salaries table like we have
here, all the records with matching value in both tables will be given as an output. 
Unlike LEFT JOIN that we looked at before. Here, the order of the table does not really matter. */


/* 5.3: Retrieve a list of employee number, first name and last name.
Add a column called 'salary difference' which is the difference between the
employees' maximum and minimum salary. Also, add a column called
'salary_increase', which returns 'Salary was raised by more than $30,000' if the difference 
is more than $30,000, 'Salary was raised by more than $20,000 but less than $30,000',
if the difference is between $20,000 and $30,000, 'Salary was raised by less than $20,000'
if the difference is less than $20,000 */
SELECT e.emp_no, e.first_name, e.last_name, MAX(s.salary) - MIN(s.salary) AS salary_difference,
CASE
	WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
	WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 
	THEN 'Salary was raised by more than $20,000 but less than $30,000'
	ELSE 'Salary was raised by less than $20,000'
END AS salary_increase
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
GROUP BY e.emp_no, s.emp_no; -- again, use GROUP BY when using aggregate function


-- 5.4: Retrieve all the data from the employees and dept_emp tables
SELECT * FROM employees;

SELECT * FROM dept_emp;
/* Note: In the to_date column, the year 9999 means the employment status of the employee is still active in our 
company database. */

/* 5.5: Extract the employee number, first and last name of the first 100 employees, 
and add a fourth column called "current_employee" saying "Is still employed",
if the employee is still working in the company, or "Not an employee anymore",
if they are not more working in the company.
Hint: We will need data from both the 'employees' and 'dept_emp' table to solve this exercise */

SELECT e.emp_no, e.first_name, e.last_name,
CASE
	WHEN MAX(de.to_date) > CURRENT_DATE THEN 'Is still employed' -- we are using a date-time function CURRENT_DATE as our determinator or employment status.
    ELSE 'Not an employee anymore'
END AS current_employee
FROM employees e
JOIN dept_emp de 
ON e.emp_no = de.emp_no
GROUP BY e.emp_no
LIMIT 100;

-- Let's add the "to_date" column from dept_emp table and group the records accordingly
SELECT e.emp_no, e.first_name, e.last_name, de.to_date,
CASE
	WHEN MAX(de.to_date) > CURRENT_DATE THEN 'Is still employed' -- we are using a date-time function CURRENT_DATE as our determinator or employment status.
    ELSE 'Not an employee anymore'
END AS current_employee
FROM employees e
JOIN dept_emp de 
ON e.emp_no = de.emp_no
GROUP BY e.emp_no, de.to_date
LIMIT 100;


#############################
-- Task Six: Transposing data using the CASE clause
-- In this task, we will learn how to use the SQL CASE statement to
-- transpose retrieved data
#############################

-- 6.1: Retrieve all the data from the sales table
SELECT * FROM sales;

-- 6.2: Retrieve the count of the different profit_category from the sales table
SELECT a.profit_category, COUNT(*)
FROM (
SELECT order_line, profit,
CASE
	WHEN profit < 0 THEN 'No Profit'
	WHEN profit > 0 AND profit < 500 THEN 'Low Profit'
	WHEN profit > 500 AND profit < 1500 THEN 'Good Profit'
	ELSE 'High Profit'
END AS profit_category 
FROM sales
) a
GROUP BY a.profit_category;
/* So, what we've tried to do here, is we want to count how many,
from our sales table are affected with the conditions we set above.
We want to know how many different records fall
into this profit category by writing a simple, subquery here, just
like we've seen before. 
The profit values we set here are just for explanation purposes and is no way related to any world standard.
*/

/* The next thing we want to do with the CASE statement is to
transpose this result to horizontal form. */
-- 6.3: Transpose 6.2 above
SELECT SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS no_profit -- we want to now sum up every occurrence 
FROM sales;															-- where the profit is less than zero else, put zero.

/* We'll see now that no_profit is now 1871 but it's now in
the horizontal manner. We'll do the same thing now for the next one.*/
SELECT SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS no_profit,
SUM(CASE WHEN profit > 0 AND profit < 500 THEN 1 ELSE 0 END) AS low_profit
FROM sales;

-- Let's complete the transposition
SELECT SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS no_profit,
SUM(CASE WHEN profit > 0 AND profit < 500 THEN 1 ELSE 0 END) AS low_profit,
SUM(CASE WHEN profit > 500 AND profit < 1500 THEN 1 ELSE 0 END) AS good_profit,
SUM(CASE WHEN profit > 1500 THEN 1 ELSE 0 END) AS high_profit
FROM sales;


-- 6.4: Retrieve the number of employees in the first four departments in the dept_emp table
-- Let's retrieve the data in this department employment table first.
SELECT * FROM dept_emp;
/* In this particular table, there must have been more than one
person, for example, in department number four, we can see these two
people are in department number four.

So, we want to know how many people are in each of these departments? */
SELECT dept_no, COUNT(*) 
FROM dept_emp
WHERE dept_no IN ('d001', 'd002', 'd003', 'd004') -- there are actually 9 departments if we check the departments table. But for this query, we are only considering the first four.
GROUP BY dept_no
ORDER BY dept_no;
/* Our task now is to transform this like what we did before. */

-- 6.5: Transpose 6.4 above
SELECT 
SUM(CASE WHEN dept_no = 'd001' THEN 1 ELSE 0 END) AS dept_one,
SUM(CASE WHEN dept_no = 'd002' THEN 1 ELSE 0 END) AS dept_two,
SUM(CASE WHEN dept_no = 'd003' THEN 1 ELSE 0 END) AS dept_three,
SUM(CASE WHEN dept_no = 'd004' THEN 1 ELSE 0 END) AS dept_four
FROM dept_emp;

/* Brilliant! And this changes the vertical result to the horizontal
form. */
