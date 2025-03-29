CREATE DATABASE CourseManagement;
USE CourseManagement;

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY ,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Expertise VARCHAR(255) NOT NULL
);


CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(255) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Duration INT NOT NULL,
    InstructorID INT NOT NULL,
    CONSTRAINT FK_Courses_Instructors FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID) ON DELETE CASCADE
);


CREATE TABLE Students (
    StudentID INT PRIMARY KEY ,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);


CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Enrollments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    CONSTRAINT FK_Enrollments_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    UNIQUE (StudentID, CourseID)
);


CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY ,
    StudentID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME ,
    CONSTRAINT FK_Payments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);


CREATE TABLE Assessments (
    AssessmentID INT PRIMARY KEY ,
    CourseID INT NOT NULL,
    AssessmentType VARCHAR(50) NOT NULL,
    TotalMarks INT NOT NULL,
    CONSTRAINT FK_Assessments_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);


INSERT INTO Instructors (InstructorID, FullName, Email, Expertise) VALUES
(1, 'John Doe', 'john.doe@example.com', 'Computer Science'),
(2, 'Jane Smith', 'jane.smith@example.com', 'Business Administration');

-- Insert data into Courses
INSERT INTO Courses (CourseID, CourseName, Category, Duration, InstructorID) VALUES
(11, 'Database Management', 'Technology', 40, 1),
(22, 'Marketing Strategies', 'Business', 35, 2);

INSERT INTO Courses (CourseID, CourseName, Category, Duration, InstructorID) VALUES
(33, 'Data Science Fundamentals', 'Technology', 50, 1),
(44, 'Business Analytics', 'Business', 40, 2),
(55, 'Software Engineering', 'Technology', 45, 1);

INSERT INTO Courses (CourseID, CourseName, Category, Duration, InstructorID) VALUES
(66, 'Python', 'Programming', 50, 1)

INSERT INTO Students (StudentID, FullName, Email, PhoneNumber) VALUES
(111, 'Alice Johnson', 'alice.johnson@example.com', '1234567890'),
(222, 'Bob Williams', 'bob.williams@example.com', '0987654321');

INSERT INTO Students (StudentID, FullName, Email, PhoneNumber) VALUES
(333, 'Charlie Brown', 'charlie.brown@example.com', '5678901234');


-- Insert data into Enrollments
INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(51, 111, 11, GETDATE()),
(52, 222, 22, '2025-01-02');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(53, 222, 33, GETDATE()),
(54, 222, 44, '2024-09-02 13:20:00'),
(55, 222, 55, '2024-07-31 10:30:00');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(56, 333, 11, '2024-06-15');

INSERT INTO Payments (PaymentID, StudentID, AmountPaid, PaymentDate) VALUES
(91, 111, 200.00, GETDATE()),
(92, 222, 150.00, GETDATE());

-- Insert data into Assessments
INSERT INTO Assessments (AssessmentID, CourseID, AssessmentType, TotalMarks) VALUES
(12345, 11, 'Quiz', 100),
(23456, 22, 'Assignment', 50);

SELECT * FROM Instructors; 
SELECT * FROM Courses; 
SELECT * FROM Students; 
SELECT * FROM Enrollments; 
SELECT * FROM Payments; 
SELECT * FROM Assessments;

/*
3.	Retrieve Available Courses:
o	Write an SQL query to list all courses, including their Course Name, Category, Duration, and Instructor Name.*/
SELECT C.CourseName,C.Duration,C.Category,I.FullName AS InstructorName FROM Courses C JOIN Instructors I ON C.InstructorID=I.InstructorID;

/*4.	Retrieve Students Enrolled in a Specific Course:
o	Write a query to fetch the Student Name, Email, and Enrollment Date for students enrolled in a course (use a parameter for CourseID).*/
SELECT S.FullName , S.Email, E.EnrollmentDate,E.CourseID FROM Students S JOIN Enrollments E ON S.StudentID=E.StudentID
WHERE E.CourseID=22;

/*5.	Update Instructor Information (Stored Procedure):
o	Create a stored procedure to update an instructor's Full Name and Email based on InstructorID.*/
GO
CREATE PROCEDURE UpdateInstructor
	@instructorID INT,
	@newName VARCHAR(20),
	@newMail VARCHAR(50)
AS
	UPDATE Instructors SET FullName=@newName, Email=@newMail WHERE InstructorID=@instructorID
EXEC UpdateInstructor @instructorID=2, @newName='Rambo Shawn', @newMail='rambo@demo.com';


/*6.	Calculate Total Payments per Student:
o	Write an SQL query to retrieve the Student Name and Total Amount Paid.
o	Ensure that students with no payments are still included.*/
SELECT S.FullName,P.AmountPaid FROM Students S JOIN Payments P ON S.StudentID=P.StudentID;

/*7.	Retrieve Students Without Enrollments:
o	Fetch a list of students who have not enrolled in any course.*/
SELECT S.FullName from Students S JOIN Enrollments E ON E.StudentID=S.StudentID
WHERE E.EnrollmentID IS NULL;

/*8.	Retrieve Monthly Revenue:
o	Write an SQL query to calculate total payments received per month and year.*/
SELECT SUM(AmountPaid) AS ToatalPayment, MONTH(PaymentDate) AS MONTH, YEAR(PaymentDate) AS YEAR FROM Payments GROUP BY MONTH(PaymentDate), YEAR(PaymentDate)
ORDER BY YEAR(PaymentDate) DESC, MONTH(PaymentDate) DESC;

/*9.	Find Students Enrolled in More Than 3 Courses:
o	Retrieve student details for those who have enrolled in more than 3 courses.*/
SELECT S.StudentID,S.FullName,S.Email,S.PhoneNumber, COUNT(E.CourseID) AS TotalCourses FROM Students S JOIN Enrollments E 
ON S.StudentID=E.StudentID  GROUP BY S.StudentID,S.FullName, S.Email, S.PhoneNumber HAVING COUNT(E.CourseID) > 3; 

/*10.	Retrieve Instructor-wise Course Count:
•	List Instructors along with the number of courses they are teaching.*/
SELECT I.FullName AS InstructorName, COUNT(C.CourseID) AS CourseCount FROM Instructors I 
JOIN Courses C ON I.InstructorID=C.InstructorID GROUP BY I.FullName;

/*11.	Find Students Without Payments:
•	Write a query to retrieve students who have enrolled in at least one course but have not made any payment.*/
SELECT S.StudentID, S.FullName, S.Email, S.PhoneNumber FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID LEFT JOIN Payments P ON S.StudentID = P.StudentID
WHERE P.StudentID IS NULL GROUP BY S.StudentID, S.FullName, S.Email, S.PhoneNumber;


/*12.	Retrieve Courses with No Enrollments:
•	Fetch a list of courses that have never been enrolled in.*/
SELECT C.CourseID,C.CourseName FROM Courses C LEFT JOIN Enrollments E ON C.CourseID = E.CourseID
WHERE E.CourseID IS NULL;

/*13.	Find the Most Popular Course:
•	Write an SQL query to determine the course with the highest number of enrollments.*/
SELECT TOP 1 E.CourseID,C.CourseName,COUNT(E.EnrollmentID) AS EnrollmentCount FROM Enrollments E 
JOIN Courses C ON E.CourseID=C.CourseID
GROUP BY E.CourseID,C.CourseName ORDER BY EnrollmentCount DESC;

/*14.	Retrieve Students and Their Total Marks in a Course:
•	Write a query that retrieves each student’s name, course name, and their total assessment marks.*/
SELECT S.FullName, C.CourseName, SUM(A.TotalMarks) AS Total FROM Enrollments E JOIN Students S ON E.StudentID=S.StudentID
JOIN Courses C ON C.CourseID=E.CourseID
JOIN Assessments A ON A.CourseID=C.CourseID GROUP BY S.FullName,C.CourseName;

/*15.	List Courses with Assessments but No Enrollments:
•	Find courses that have assessments but no student enrollments.*/
SELECT C.CourseName FROM Courses C LEFT JOIN Enrollments E ON C.CourseID=E.CourseID WHERE E.CourseID IS NULL;

/*16.	Retrieve Payment Status per Student:
•	Display each student's name, number of enrolled courses, and total amount paid.*/
SELECT S.FullName, COUNT(E.CourseID) AS CourseCount, SUM(DISTINCT P.AmountPaid) AS TotalAmt FROM Students S 
LEFT JOIN Enrollments E ON S.StudentID=E.StudentID
LEFT JOIN Payments P ON S.StudentID=P.StudentID GROUP BY S.FullName;

/*17.	Find Course Pairs with the Same Instructor:
•	List pairs of courses that are taught by the same instructor.*/
SELECT C1.CourseID AS Course1_ID, C1.CourseName AS Course1_Name, 
C2.CourseID AS Course2_ID, C2.CourseName AS Course2_Name, 
C1.InstructorID, I.FullName AS InstructorNam FROM Courses C1
JOIN Courses C2 ON C1.InstructorID = C2.InstructorID AND C1.CourseID < C2.CourseID
JOIN Instructors I ON C1.InstructorID = I.InstructorID ORDER BY C1.InstructorID, C1.CourseID;


/*18.	List All Possible Student-Course Combinations:
•	Retrieve a Cartesian product of all students and courses (potential enrollments).*/
SELECT S.FullName,C.CourseName FROM Students S CROSS JOIN Courses C ;

/*19.	Determine the Instructor with the Highest Number of Students:
•	Find the Instructor Name and the number of students enrolled in their courses.*/
SELECT I.FullName,COUNT(E.EnrollmentID) FROM Courses C 
JOIN Instructors I ON C.InstructorID=I.InstructorID
JOIN Enrollments E ON C.CourseID=E.CourseID
GROUP BY I.FullName;

/*20.	Trigger to Prevent Double Enrollment:
•	Create a trigger to prevent a student from enrolling in the same course more than once.*/
GO
CREATE TRIGGER PreventDEnrollment
ON Enrollments
AFTER INSERT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Enrollments E  JOIN inserted I ON E.StudentID=I.StudentID AND E.CourseID=I.CourseID)
	BEGIN
		THROW 50000, 'A student cannot enroll in the same course more than once.', 1;
	END
END

INSERT INTO Courses (CourseID, CourseName, Category, Duration, InstructorID)
VALUES (99, 'New Course', 'Technology', 40, 1);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES (101, 111, 99, GETDATE());


