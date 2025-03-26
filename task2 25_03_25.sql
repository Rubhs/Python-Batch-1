

/* 1) Write a query to list all system databases available in MS SQL Server.*/
SELECT * FROM sys.databases;


/*2) Write a query to retrieve the physical file locations (MDF & LDF) of a database named "CompanyDB".*/
SELECT name, type_desc from sys.master_files WHERE database_ID = DB_ID('CompanyDB');


/*3) Write a query to create a database "HRDB" with the following specifications:

Primary Data File: 10MB, Autogrow by 2MB

Log File: 5MB, Autogrow by 1MB */
--CREATE DATABASE HRDB;
EXEC sp_helpfile;

CREATE DATABASE HRDB 
ON PRIMARY (NAME ='HRDB_DATA' ,FILENAME ='D:\HRDB\HRDB.MDF' , SIZE=5MB ,MAXSIZE=25MB, FILEGROWTH=2MB )
LOG ON (NAME ='HRDB_LOG' , FILENAME='D:\HRDB\HRDB.LDF' , SIZE=5MB , MAXSIZE=10MB , FILEGROWTH=1MB);

/*4) Rename "HRDB" to "EmployeeDB" using SQL commands.*/
ALTER DATABASE HRDB MODIFY NAME=EmployeeDB;


/*5) Drop the database "EmployeeDB" from the system.*/
DROP DATABASE EmployeeDB;


/*6)Write a query to display all supported data types in MS SQL Server.*/
SELECT name FROM sys.types;


/*7)Create a table "Employees" with the following fields:

EmpID (Integer, Primary Key)

EmpName (Variable-length string, max 100 characters, Not Null)

JoinDate (Date, Not Null)

Salary (Decimal with 2 decimal places, Default: 30000.00) */
CREATE TABLE Employees ( EmpID INT PRIMARY KEY ,
						 EmpName VARCHAR(100) NOT NULL,
						 JoinDate DATE NOT NULL);


/*8)Add a new column "Department" (VARCHAR(50)) to the "Employees" table.*/
ALTER TABLE Employees ADD Department VARCHAR(50);


/*9)Rename the table "Employees" to "Staff".*/
EXEC sp_rename 'Employees','Staff';

/*10)Drop the table "Staff" from the database.*/
DROP TABLE Staff;