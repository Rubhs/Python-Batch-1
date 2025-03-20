--------TASK 1

create database TechShop;
use TechShop;
create table Customers( customerID int PRIMARY KEY NOT NULL, 
						FirstName varchar(25), LastName  varchar(25), 
						Email varchar(25) UNIQUE, Phone varchar(12) UNIQUE, 
						Address varchar(100) );


create table Products( ProductID int PRIMARY KEY NOT NULL, 
					   ProductName varchar(100), 
					   Description varchar(100), Price int);

create table Orders( OrderID int PRIMARY KEY NOT NULL, 
					 customerID int, Description varchar(100),
					 OrderDate DATE, TotalAmount int, 
					 FOREIGN KEY (customerID) REFERENCES Customers(customerID));


create table OrderDetails( OrderDetailID int PRIMARY KEY NOT NULL,
						   OrderID int, ProductID int ,
						   Quantity  int,
						   FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
						   FOREIGN KEY (ProductID) REFERENCES Products(ProductID));


create table Inventory( InventoryID int PRIMARY KEY NOT NULL,
						ProductID int ,
						QuantityInStock  int, LastStockUpdate DATE,
						FOREIGN KEY (ProductID) REFERENCES Products(ProductID));


insert into Customers values ( 101, 'John','Doe','john.doe@demo.com', 9988776655, '04,Church Road,Salem' ),
							 ( 102, 'Ram','Kumar','ram@demo.com', 9988776654, '07,2nd aveneue,Chennai' ),
							 ( 103,'Sam','Kenny','sam@demo.com', 9988776524, '57,2nd aveneue,Bangalore' ),
							 ( 104, 'Ramya','Kannan','ramya@demo.com', 9988713654, '11/5,Park Street,Salem' ),
							 ( 105, 'Rahul','Ram','rahul@demo.com', 9984376654, '55,Main Street,Chennai' ),
							 ( 106, 'Priyanka','Pandey','priya@demo.com', 9940776654, '07,Big Ben Street,Chennai' ),
							 ( 107, 'Riela','Theresa','riels@demo.com', 9981376654, '07,1st aveneue,Hyderabad' ),
							 ( 108, 'Rithi','Mukundu','rithi@demo.com', 9988066654, '345,Kennedy Road,Chennai' ),
							 ( 109, 'Resh','Reddy','resh@demo.com', 9988776124, '07,2nd aveneue,Bangalore' ),
							 ( 110, 'Shri','Nandhini','nandy@demo.com', 5488776654, '56,Churchill Street,Hyderabad' );
							
select * from Customers;

INSERT INTO Products (ProductID, ProductName, Description, Price) VALUES
					(201, 'Laptop', 'Gaming Laptop with 16GB RAM', 80000),
					(202, 'Smartphone', 'Android phone with 128GB storage', 25000),
					(203, 'Tablet', '10-inch tablet with stylus support', 30000),
					(204, 'Smartwatch', 'Waterproof smartwatch with GPS', 15000),
					(205, 'Wireless Earbuds', 'Noise-canceling earbuds', 8000),
					(206, 'Mechanical Keyboard', 'RGB backlit gaming keyboard', 7000),
					(207, 'Monitor', '27-inch 4K monitor', 35000),
					(208, 'External HDD', '2TB external hard drive', 9000),
					(209, 'Wireless Mouse', 'Ergonomic wireless mouse', 4000),
					(210, 'Gaming Chair', 'Adjustable gaming chair with lumbar support', 20000);
select * from Products;

INSERT INTO Orders (OrderID, customerID, Description, OrderDate, TotalAmount) VALUES
					(301, 101, 'Laptop and Mouse', '2024-03-01', 84000),
					(302, 102, 'Smartphone and Earbuds', '2024-03-02', 33000),
					(303, 103, 'Tablet and Smartwatch', '2024-03-03', 45000),
					(304, 104, 'Mechanical Keyboard', '2024-03-04', 7000),
					(305, 105, 'Monitor and External HDD', '2024-03-05', 44000),
					(306, 106, 'Gaming Chair', '2024-03-06', 20000),
					(307, 107, 'Smartwatch and Wireless Mouse', '2024-03-07', 19000),
					(308, 108, 'Laptop', '2024-03-08', 80000),
					(309, 109, 'Wireless Earbuds and Mechanical Keyboard', '2024-03-09', 15000),
					(310, 110, 'Monitor and Smartwatch', '2024-03-10', 50000);
select * from Orders;

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
						(401, 301, 201, 1),  -- Laptop in Order 301
						(402, 301, 209, 1),  -- Mouse in Order 301
						(403, 302, 202, 1),  -- Smartphone in Order 302
						(404, 302, 205, 1),  -- Earbuds in Order 302
						(405, 303, 203, 1),  -- Tablet in Order 303
						(406, 303, 204, 1),  -- Smartwatch in Order 303
						(407, 305, 207, 1),  -- Monitor in Order 305
						(408, 305, 208, 1),  -- External HDD in Order 305
						(409, 309, 205, 1),  -- Earbuds in Order 309
						(410, 309, 206, 1);  -- Keyboard in Order 309
select * from OrderDetails

INSERT INTO Inventory (InventoryID, ProductID, QuantityInStock, LastStockUpdate) VALUES
						(501, 201, 15, '2024-03-01'),  -- Laptop stock
						(502, 202, 20, '2024-03-02'),  -- Smartphone stock
						(503, 203, 12, '2024-03-03'),  -- Tablet stock
						(504, 204, 25, '2024-03-04'),  -- Smartwatch stock
						(505, 205, 30, '2024-03-05'),  -- Earbuds stock
						(506, 206, 18, '2024-03-06'),  -- Keyboard stock
						(507, 207, 10, '2024-03-07'),  -- Monitor stock
						(508, 208, 22, '2024-03-08'),  -- External HDD stock
						(509, 209, 28, '2024-03-09'),  -- Mouse stock
						(510, 210, 8, '2024-03-10');   -- Gaming Chair stock


select * from Inventory

--------TASK 2

--1. Write an SQL query to retrieve the names and emails of all customers.  
SELECT CONCAT(FirstName, ' ', LastName) AS Name, Email FROM Customers;

--2. Write an SQL query to list all orders with their order dates and corresponding customer names. 
SELECT OrderID, OrderDate,(SELECT  CONCAT(FirstName, ' ', LastName) FROM Customers WHERE Customers.customerID = Orders.customerID)AS CustomerName FROM Orders

/*3. Write an SQL query to insert a new customer record into the "Customers" table. Include 
customer information such as name, email, and address. */
INSERT INTO Customers (CustomerId,FirstName, LastName, Email, Phone, Address) VALUES 
					(111,'Amit', 'Sharma', 'amit.sharma@demo.com', '9988776611', '12, Green Street, Mumbai');


/*4. Write an SQL query to update the prices of all electronic gadgets in the "Products" table by 
increasing them by 10%. */
UPDATE Products SET Price = Price * 16.10 
WHERE ProductName IN ('Laptop', 'Smartphone', 'Tablet', 'Smartwatch', 'Wireless Earbuds', 'Monitor', 'Mechanical Keyboard', 'Wireless Mouse');


select * from Products
/*5. Write an SQL query to delete a specific order and its associated order details from the 
"Orders" and "OrderDetails" tables. Allow users to input the order ID as a parameter. */
DELETE FROM OrderDetails WHERE OrderID = 301;

DELETE FROM Orders WHERE OrderID = 301;

/*6. Write an SQL query to insert a new order into the "Orders" table. Include the customer ID, 
order date, and any other necessary information. */
INSERT INTO Orders (OrderID,customerID, Description, OrderDate, TotalAmount) 
VALUES (301,101, 'Electronics Purchase', '2025-03-20', 5000);

select * from Orders;

/*7. Write an SQL query to update the contact information (e.g., email and address) of a specific 
customer in the "Customers" table. Allow users to input the customer ID and new contact 
information.*/

UPDATE Customers 
SET Email = 'newemail@demo.com', Address = '123, Updated Street, Chennai'
WHERE customerID = 103;


/* 8. Write an SQL query to recalculate and update the total cost of each order in the "Orders" 
table based on the prices and quantities in the "OrderDetails" table.*/

UPDATE Orders SET TotalAmount = (SELECT SUM(Quantity * Price) FROM OrderDetails 
    JOIN Products ON OrderDetails.ProductID = Products.ProductID 
    WHERE OrderDetails.OrderID = Orders.OrderID
);

/*9. Write an SQL query to delete all orders and their associated order details for a specific 
customer from the "Orders" and "OrderDetails" tables. Allow users to input the customer ID 
as a parameter. */

DELETE FROM OrderDetails 
WHERE OrderID IN (SELECT OrderID FROM Orders WHERE customerID = 102);

DELETE FROM Orders 
WHERE customerID = 102;

select * from Orders;

/*10. Write an SQL query to insert a new electronic gadget product into the "Products" table, 
including product name, category, price, and any other relevant details. */

INSERT INTO Products (ProductID, ProductName, Description, Price) 
VALUES (601, 'Smartphone', 'Latest 5G smartphone with AMOLED display', 45000);

/*11. Write an SQL query to update the status of a specific order in the "Orders" table (e.g., from 
"Pending" to "Shipped"). Allow users to input the order ID and the new status. */

alter table Orders add Status varchar(10);

update Orders set Status='Pending' where OrderId=301;
update Orders set Status='Pending' where OrderId=302;
update Orders set Status='Shipped' where OrderId=303;
update Orders set Status='Shipped' where OrderId=304;
update Orders set Status='Pending' where OrderId=305;
update Orders set Status='Pending' where OrderId=306;
update Orders set Status='Shipped' where OrderId=307;
update Orders set Status='Pending' where OrderId=308;
update Orders set Status='Pending' where OrderId=309;
update Orders set Status='Shipped' where OrderId=310;


UPDATE Orders SET Status = 'Shipped' WHERE OrderID = 309;

/*12. Write an SQL query to calculate and update the number of orders placed by each customer 
in the "Customers" table based on the data in the "Orders" table. */

ALTER TABLE Customers ADD TotalOrders INT DEFAULT 0;

UPDATE Customers SET TotalOrders = (SELECT COUNT(*) FROM Orders WHERE Orders.customerID = Customers.customerID);



