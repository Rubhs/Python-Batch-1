-- 1. Create a database named StudentRecords
CREATE DATABASE StudentRecords;

-- 2. Rename the StudentRecords database to UniversityRecords
ALTER DATABASE StudentRecords MODIFY NAME = UniversityRecords;

USE UniversityRecords

-- 3. Delete the UniversityRecords database safely
DROP DATABASE UniversityRecords;


---recreate UniversityRecords DB
-- 5. Create a Students table with appropriate columns and data types
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Department VARCHAR(50)
);

-- 6. Add a new column Email to the Students table
ALTER TABLE Students ADD Email VARCHAR(100);

-- 7. Rename the Students table to UniversityStudents
EXEC sp_rename 'Students', 'UniversityStudents';

-- 8. Delete the UniversityStudents table
DROP TABLE UniversityStudents;


----execute Students table creation 
-- 9. Insert five sample student records into the Students table
INSERT INTO Students (StudentID, FirstName, LastName, Age, Department, Email) VALUES
(1, 'John', 'Doe', 20, 'Computer Science', 'john.doe@example.com'),
(2, 'Alice', 'Smith', 22, 'Mathematics', 'alice.smith@example.com'),
(3, 'Bob', 'Johnson', 19, 'Physics', 'bob.johnson@example.com'),
(4, 'Mary', 'Davis', 21, 'Biology', 'mary.davis@example.com'),
(5, 'James', 'Brown', 23, 'Engineering', 'james.brown@example.com');

-- 10. Update the email of a specific student
UPDATE Students SET Email = 'new.email@example.com' WHERE StudentID = 3;

-- 11. Delete a record of a student who has graduated (example: age > 22)
DELETE FROM Students WHERE Age > 22;

-- 12. Select and display only the names and emails of students
SELECT FirstName, LastName, Email FROM Students;

-- 13. Retrieve students based on a specific condition (e.g., age > 18)
SELECT * FROM Students WHERE Age > 18;

-- 14. Fetch all records from the table
SELECT * FROM Students;

-- 15. Retrieve students who belong to a specific department
SELECT * FROM Students WHERE Department = 'Computer Science';

-- 16. Write queries to demonstrate filtering using operators
SELECT * FROM Students WHERE Department IN ('Biology','Mathematics');
SELECT * FROM Students WHERE FirstName LIKE 'A%';
SELECT * FROM Students WHERE Age BETWEEN 18 AND 20;
SELECT * FROM Students WHERE Age>20 AND Department='Biology';
SELECT * FROM Students WHERE Age>20 OR Department='Biology';
SELECT DISTINCT Department FROM Students;
SELECT CONCAT(FirstName,' ',LastName) as FullName FROM Students; 