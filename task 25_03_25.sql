
 /* 1) (2 Marks) Write a query to list all system databases in SQL Server.*/
 select * from sys.databases;


/*2) (2 Marks) Identify the physical database files (MDF, LDF) of a user-defined database named "SalesDB" using a SQL query.*/
SELECT name, physical_name FROM sys.master_files WHERE database_id = DB_ID('SalesDB');

/*3) (2 Marks) Create a user-defined database named "InventoryDB" with a primary data file of 5MB and a log file of 2MB.*/
CREATE DATABASE InventoryDB
use InventoryDB
/*ON (NAME = InventoryDB_Data, FILENAME = 'C:\InventoryDB.mdf', SIZE = 5MB)
LOG ON (NAME = InventoryDB_Log, FILENAME = 'C:\InventoryDB.ldf', SIZE = 2MB);*/

/*4) (2 Marks) Rename the database "InventoryDB" to "StockDB" using a SQL query.*/
alter database InventoryDB modify name=StockDB;
use taskBase;
/*5) (2 Marks) Drop the database "StockDB" using a SQL query.*/
drop database StockDB;

/*6) (2 Marks) Write a query to display all available data types in SQL Server.*/
SELECT name AS DataType FROM sys.types;


/*7) (2 Marks) Create a table "Products" with the following columns:
    ProductID (Integer, Primary Key)

ProductName (Variable-length string, max 50 characters, Not Null)

Price (Decimal with 2 decimal places)

StockQuantity (Integer, Default value 0)*/

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2),
    StockQuantity INT DEFAULT 0
);

/*8)(2 Marks) Modify the "Products" table to add a new column Category (VARCHAR(30)).*/
ALTER TABLE Products ADD Category VARCHAR(30);

/*9)(2 Marks) Rename the table "Products" to "Inventory".*/
EXEC sp_rename 'Products', 'Inventory';

/*10)(2 Marks) Drop the "Inventory" table from the database.*/
DROP TABLE Inventory;

/*11)(5 Marks) Identify and list the system databases available in SQL Server. Provide a brief description of each.
The system databases in SQL Server are:
 1. **master**: Stores system-level metadata and configuration.
 2. **model**: Template for new databases.
 3. **msdb**: Used by SQL Server Agent for scheduling jobs, alerts, and backups.
 4. **tempdb**: Temporary storage for intermediate query results and temporary tables.*/

/*12)(5 Marks) Write a query to display all database files (MDF, LDF, NDF) for a specific database.*/
SELECT name, type_desc, physical_name FROM sys.master_files WHERE database_id = DB_ID('TechShop');

/*13) (5 Marks) Create a new user-defined database named SalesDB with a primary data file of 10MB and a log file of 5MB.*/
CREATE DATABASE SalesDB

/*14)(5 Marks) Rename the database SalesDB to RetailDB using an SQL query.*/
ALTER DATABASE SalesDB MODIFY NAME = RetailDB;

/*15) (5 Marks) Drop the RetailDB database safely, ensuring that no active connections exist before deletion.*/
ALTER DATABASE RetailDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE RetailDB;