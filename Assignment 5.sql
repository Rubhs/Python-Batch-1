/*1. Storing Data in a Table (3 Marks)
a) Write an SQL query to create a table named Employees with the following fields:
•	EmployeeID (Primary Key, INT, Auto-increment)
•	Name (VARCHAR(100), NOT NULL)
•	Age (INT)
•	Department (VARCHAR(50))
•	Salary (DECIMAL(10,2))
b) Insert three records into the Employees table.
*/

CREATE DATABASE Task5;
USE Task5;

CREATE TABLE Employees ( EmployeeID INT IDENTITY(1,1) PRIMARY KEY ,
						 Name VARCHAR(100) NOT NULL, Age INT,
						 Department VARCHAR(50),
						 Salary DECIMAL(10,2) );

INSERT INTO Employees (Name, Age, Department, Salary) VALUES
					  ('RAM',27,'IT',60000), 
					  ('SAM',40,'HR',100000),
					  ('RAHUL',62,'FINANCE',1500000);
SELECT * FROM Employees;

/*2. Updating Data in a Table (3 Marks)
Write an SQL query to update the Salary of employees in the HR department by 10%.
*/
UPDATE Employees SET Salary = Salary*1.10 WHERE Department = 'HR';

/*3. Deleting Data from a Table (3 Marks)
Write an SQL query to delete all employees from the IT department.
*/
DELETE FROM Employees WHERE Department = 'IT';

/*4. Demo: Manipulating Data in Tables (6 Marks)
a) Insert a new employee into the Employees table, but ensure the Salary is at least 30000. (2 Marks)
b) Update the Department of employees who earn more than 50000 to Senior Staff. (2 Marks)
c) Delete employees older than 60 years from the table. (2 Marks)
*/
INSERT INTO Employees (Name, Age, Department, Salary) VALUES
					  ('PRIYA',32,'FINANCE',50000);

UPDATE Employees SET Department = 'Senior Staff' WHERE Salary > 50000 ;

DELETE FROM Employees WHERE Age>60;

/*5. Retrieving Specific Attributes (3 Marks)
Write an SQL query to retrieve only the Name and Salary of all employees.
*/
SELECT Name, Salary FROM Employees;

/*6. Retrieving Selected Rows (3 Marks)
Write an SQL query to retrieve employees from the HR department who have a salary greater than 50,000.
*/
SELECT * FROM Employees WHERE Salary>50000;

/*7. Demo: Retrieving Data (4 Marks)
Write an SQL query to retrieve all employees sorted by Salary in descending order.
*/
SELECT * FROM Employees ORDER BY Salary DESC;

/*8. Filtering Data - WHERE Clauses (5 Marks)
a) Write an SQL query to retrieve employees whose Age is greater than 30. (2 Marks)
b) Retrieve employees whose Department is either HR or Finance. (3 Marks)
*/
SELECT * FROM Employees WHERE Age>30;
SELECT * FROM Employees WHERE Department='HR' OR Department='FINANCE';

/*9. Filtering Data - Operators (10 Marks)
a) Retrieve employees whose Salary is between 30,000 and 60,000. (2 Marks)
b) Retrieve employees whose Name starts with "A". (2 Marks)
c) Retrieve employees who do NOT belong to the IT department. (2 Marks)
d) Retrieve employees whose Department is either "Sales" or "Marketing" using the IN operator. (2 Marks)
e) Retrieve employees with distinct Department names. (2 Marks)
*/
SELECT * FROM Employees WHERE Salary BETWEEN 30000 AND 60000;
SELECT * FROM Employees WHERE Name LIKE 'A%';
SELECT * FROM Employees WHERE NOT Department = 'IT';
SELECT * FROM Employees WHERE Department IN ('Sales','Marketing');
SELECT DISTINCT(Department) FROM Employees;

/*10. Column & Table Aliases (3 Marks)
Write an SQL query that retrieves EmployeeID, Name, and Salary, renaming EmployeeID as "ID" and Salary as "Monthly Income".
*/
SELECT EmployeeID AS ID, Name, Salary AS MonthlyIncome FROM Employees;

/*11. Demo: Filtering Data (4 Marks)
Write an SQL query to retrieve employees whose Name contains "John" and whose salary is greater than 40,000.
*/
SELECT * FROM Employees WHERE Name LIKE '%John%' AND Salary>40000;