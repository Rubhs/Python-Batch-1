/*Task 2
1)Create a user-defined database named EmployeeRecords with specific file paths for the .mdf and .ldf files.*/
CREATE DATABASE EmployeeRecords

/*
2) Rename the EmployeeRecords database to HR_Database using T-SQL.*/
ALTER DATABASE EmployeeRecords MODIFY name=HR_Database

/*3)Drop the HR_Database safely, ensuring there are no active connections before deletion.*/
DROP DATABASE HR_Database;

/*4)Identify at least five commonly used data types in SQL Server and explain their use cases.*/

USE HR_Database;

/*5)Create a Customers table with appropriate columns (CustomerID, FullName, Email, Phone, DateJoined).*/
CREATE TABLE Customers ( CustomerID INT PRIMARY KEY, 
						FullName VARCHAR(25), Email VARCHAR(25),
						Phone CHAR(13), DateJoined DATE);

/*6)Modify the Customers table to add a new column Address.*/
ALTER TABLE Customers ADD Address VARCHAR(100);

/*7)Rename the Customers table to ClientDetails.*/
EXEC sp_rename 'Customers','ClientDetails';

/*8)Drop the ClientDetails table safely.*/
DROP TABLE ClientDetails;

--RECREATE Customers table
DELETE FROM Customers
DROP TABLE Customers;
SELECT * FROM Customers;
/*9)Insert five sample records into the Customers table.*/
INSERT INTO Customers (CustomerID, FullName, Email, Phone, DateJoined)  VALUES 
					  (1, 'JOHN DOE', 'john.doe@demo.com', '+31 789456123', '2025-03-02'),
					  (2, 'RAM KUMAR', 'ram.kumar@demo.com', '+31 789456123', '2024-03-02'),
					  (3, 'PRADEEP', 'pradeep@demo.com', '+31 789456123', '2025-01-12'),
					  (4, 'GLOSS SAM', 'sam@demo.com', '+31 789456123', '2022-09-12'),
					  (5, 'RYNA PASCAL', 'ryna@demo.com', '+31 789456123', '2021-10-13');

/*10)Update the email of a customer whose CustomerID = 3.*/
UPDATE Customers SET Email = 'deep.io@gmail.com' WHERE CustomerID = 3

/*11)Delete a customer record where the CustomerID = 5.*/
DELETE FROM Customers WHERE  CustomerID = 5

/*12)Demonstrate inserting multiple records in a single query for better efficiency. 
QUERY 9*/


/*13)Retrieve and display only the FullName and Email of all customers.*/
SELECT FullName, Email FROM Customers;

/*14)Retrieve all customers who joined after 2020-01-01.*/
SELECT * FROM Customers WHERE DateJoined > '2020-01-01'

/*15)Fetch all customers whose names start with 'J' using a LIKE query.*/
SELECT * FROM Customers WHERE FullName LIKE 'J%';

/*16)Retrieve customers where Phone is NULL (i.e., customers who haven't provided a phone number).*/
SELECT * FROM Customers WHERE Phone = NULL;

/*17)Filter customers using IN—Retrieve records where CustomerID is either 1, 3, or 7.*/
SELECT * FROM Customers WHERE CustomerId IN (1,3,7);

/*18)Use DISTINCT to list unique domain names from customer emails (e.g., gmail.com, yahoo.com).*/
SELECT DISTINCT SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Domain  
FROM Customers;


/*19)Use AND and OR together—Retrieve customers who either live in 'New York' OR have joined before 2019-06-01.*/
ALTER TABLE Customers ADD City VARCHAR(25);
UPDATE Customers SET City ='New York' WHERE CustomerId=1;
UPDATE Customers SET City ='Chicago' WHERE CustomerId=2;
UPDATE Customers SET City ='Las Vegas' WHERE CustomerId=3;
UPDATE Customers SET City ='New York' WHERE CustomerId=4;
UPDATE Customers SET City ='Las Vegas' WHERE CustomerId=5;
SELECT * FROM Customers WHERE City = 'New York' OR DateJoined < '2019-06-01'

/*20)Retrieve customers where DateJoined is BETWEEN 2018-01-01 AND 2023-12-31.*/
SELECT * FROM Customers  WHERE DateJoined BETWEEN '2018-01-01' AND '2023-12-31';

/*21)Use column and table aliases to rename output fields while selecting.*/
SELECT C.CustomerID AS ID,  C.FullName AS Name,  C.Email AS Contact_Email,  C.DateJoined AS Membership_Date  FROM Customers AS C;

/*22)Demonstrate a query that filters using multiple conditions, such as WHERE Age > 25 AND City = 'Chicago'.*/
ALTER TABLE Customers ADD Age INT;
UPDATE Customers SET Age =22 WHERE CustomerId=1;
UPDATE Customers SET Age =27 WHERE CustomerId=2;
UPDATE Customers SET Age =28 WHERE CustomerId=3;
UPDATE Customers SET Age =30 WHERE CustomerId=4;
SELECT * FROM Customers  WHERE Age > 25 AND City = 'Chicago';

/*23)Execute and analyze filtering queries to optimize performance using EXPLAIN plans (if applicable). */
SET SHOWPLAN_ALL ON;
GO
SELECT * FROM Customers WHERE Age > 25 AND City = 'Chicago';
GO
SET SHOWPLAN_ALL OFF;
