CREATE DATABASE HotelManagement;
USE HotelManagement;

CREATE TABLE Hotels ( HotelID INT PRIMARY KEY,
					  Name VARCHAR(50), LOCATION VARCHAR(100),
					  RATING DECIMAL(2,1) CHECK (Rating BETWEEN 1 AND 5));

CREATE TABLE Rooms ( RoomID INT PRIMARY KEY,
					 HotelID INT ,
					 RoomNumber VARCHAR(50), RoomType VARCHAR(100),
					 PricePerNight DECIMAL(10,2) CHECK (PricePerNight >= 0),
					 Available BIT,
					 CONSTRAINT FK_ROOMS_HOTELS FOREIGN KEY(HotelID) REFERENCES Hotels(HotelID) ON DELETE CASCADE);

CREATE TABLE Guests (GuestID INT PRIMARY KEY,
					FullName VARCHAR(255),
					Email VARCHAR(255) UNIQUE ,
					PhoneNumber NVARCHAR(20) UNIQUE ,
					CheckInDate DATETIME ,
					CheckOutDate DATETIME );

CREATE TABLE Bookings (BookingID INT IDENTITY(1,1) PRIMARY KEY,
						GuestID INT NOT NULL,
						RoomID INT NOT NULL,
						BookingDate DATETIME DEFAULT GETDATE(),
						TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
						Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Confirmed', 'Cancelled', 'Checked Out')),
						CONSTRAINT FK_Bookings_Guest FOREIGN KEY (GuestID) REFERENCES Guests(GuestID) ON DELETE CASCADE,
						CONSTRAINT FK_Bookings_Room FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE);

CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL CHECK (AmountPaid >= 0),
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(50) NOT NULL CHECK (PaymentMethod IN ('Credit Card', 'Cash', 'Debit Card', 'Bank Transfer')),
    CONSTRAINT FK_Payments_Booking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    HotelID INT NOT NULL,
    EventName NVARCHAR(255) NOT NULL,
    EventDate DATETIME NOT NULL,
    Venue NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Events_Hotel FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID) ON DELETE CASCADE
);

CREATE TABLE EventParticipants (
    ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantName NVARCHAR(255) NOT NULL,
    ParticipantType NVARCHAR(50) NOT NULL CHECK (ParticipantType IN ('Guest', 'Organization')),
    EventID INT NOT NULL,
    CONSTRAINT FK_EventParticipants_Event FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);

SELECT * FROM Hotels;

INSERT INTO Hotels (HotelID,Name, Location, Rating)VALUES 
    (1001,'Grand Palace Hotel', 'New York', 4.5),
    (1002,'Sunset Resort', 'Miami', 4.2),
    (1003,'Ocean View Hotel', 'Los Angeles', 4.8),
    (1004,'Mountain Retreat', 'Denver', 4.1);

INSERT INTO Rooms (RoomID, HotelID, RoomNumber, RoomType, PricePerNight, Available)
VALUES (90,1001, '101', 'Single', 120.00, 1),
		(91,1001, '102', 'Double', 180.00, 1),
		(92,1002, '201', 'Suite', 250.00, 1),
		(93,1002, '202', 'Single', 100.00, 1),
		(94,1003, '301', 'Double', 200.00, 1),
		(95,1003, '302', 'Suite', 300.00, 0),
		(96,1004, '401', 'Single', 90.00, 1);

SELECT * FROM Rooms ;

INSERT INTO Guests (GuestID, FullName, Email, PhoneNumber, CheckInDate, CheckOutDate)
VALUES 
    (777,'John Doe', 'john.doe@example.com', '1234567890', '2025-03-25 14:00:00', '2025-03-30 12:00:00'),
    (778,'Alice Smith', 'alice.smith@example.com', '9876543210', '2025-03-20 15:00:00', '2025-03-25 11:00:00'),
    (779,'Michael Johnson', 'michael.j@example.com', '5558887777', '2025-03-22 13:00:00', '2025-03-28 10:00:00');


INSERT INTO Bookings (GuestID, RoomID, BookingDate, TotalAmount, Status)
VALUES (777, 91, GETDATE(), 600.00, 'Confirmed'),
		(778, 93, GETDATE(), 1250.00, 'Confirmed'),
		(779, 92, GETDATE(), 1000.00, 'Checked Out');

SELECT * FROM Bookings ;

INSERT INTO Payments (BookingID, AmountPaid, PaymentDate, PaymentMethod)
VALUES (4, 600.00, GETDATE(), 'Credit Card'),
		(5, 1250.00, GETDATE(), 'Cash'),
		(6, 1000.00, GETDATE(), 'Debit Card');

INSERT INTO Events (HotelID, EventName, EventDate, Venue)
VALUES (1001, 'Business Conference 2025', '2025-04-15 10:00:00', 'Grand Ballroom'),
		(1002, 'Wedding Reception', '2025-06-20 18:00:00', 'Banquet Hall'),
		(1003, 'Tech Meetup', '2025-05-10 14:00:00', 'Conference Room A');

SELECT * FROM Events ;

/* 4. Write an SQL query to retrieve a list of available rooms for booking (Available = 1).*/
SELECT RoomID, HotelID, RoomNumber, RoomType, PricePerNight FROM Rooms WHERE Available = 1;

/*5.Retrieve names of participants registered for a specific hotel event using an @EventID parameter.*/
DECLARE @EventID INT = 1; 

SELECT ParticipantName, ParticipantType FROM EventParticipants WHERE EventID = @EventID;

/*6	Create a stored procedure that allows a hotel to update its information (name and location) in the "Hotels" table.*/
GO
CREATE PROCEDURE UpdateHotelInfo
    @HotelID INT,
    @NewName NVARCHAR(255),
    @NewLocation NVARCHAR(255) 
AS
    UPDATE Hotels SET Name = @NewName, Location = @NewLocation WHERE HotelID = @HotelID;

EXEC UpdateHotelInfo @HotelID = 1005, @NewName = 'Luxury Grand Hotel', @NewLocation = 'Las Vegas';


/* 7.	Write an SQL query to calculate the total revenue generated by each hotel from confirmed bookings */
SELECT h.HotelID, h.Name, SUM(b.TotalAmount) AS TotalRevenue
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
JOIN Bookings b ON r.RoomID = b.RoomID
WHERE b.Status = 'Confirmed'
GROUP BY h.HotelID, h.Name;

/*8.	Find rooms that have never been booked by selecting their details from the Rooms table. */
SELECT r.* FROM Rooms r LEFT JOIN Bookings b ON r.RoomID = b.RoomID WHERE b.RoomID IS NULL;

/*9.	Retrieve total payments per month and year, ensuring missing months are handled properly.*/
WITH MonthTable AS (
    SELECT DISTINCT YEAR(PaymentDate) AS Year, MONTH(PaymentDate) AS Month
    FROM Payments
)
SELECT 
    mt.Year, mt.Month, 
    COALESCE(SUM(p.AmountPaid), 0) AS TotalPayments
FROM MonthTable mt
LEFT JOIN Payments p 
    ON YEAR(p.PaymentDate) = mt.Year AND MONTH(p.PaymentDate) = mt.Month
GROUP BY mt.Year, mt.Month
ORDER BY mt.Year DESC, mt.Month DESC;

/*10.	Retrieve a list of room types that are either priced between $50 and $150 per night or above $300 per night.*/
SELECT DISTINCT RoomType 
FROM Rooms
WHERE PricePerNight BETWEEN 50 AND 150 
   OR PricePerNight > 300;


/*11.	Retrieve rooms along with their guests, including only rooms that are currently occupied.*/
SELECT r.RoomID, r.RoomNumber, r.RoomType, g.FullName, g.CheckInDate, g.CheckOutDate
FROM Bookings b
JOIN Rooms r ON b.RoomID = r.RoomID
JOIN Guests g ON b.GuestID = g.GuestID
WHERE g.CheckInDate <= GETDATE() AND (g.CheckOutDate IS NULL OR g.CheckOutDate >= GETDATE());


/*12.	Find the total number of participants in events held in a specific city (@CityName).*/
DECLARE @CityName NVARCHAR(255) = 'New York';
SELECT COUNT(ep.ParticipantID) AS TotalParticipants
FROM EventParticipants ep
JOIN Events e ON ep.EventID = e.EventID
JOIN Hotels h ON e.HotelID = h.HotelID
WHERE h.Location = @CityName;

/* 13.	Retrieve a list of unique room types available in a specific hotel. */
DECLARE @HotelID INT = 1001;
SELECT DISTINCT RoomType
FROM Rooms
WHERE HotelID = @HotelID;


/* 14.	Find guests who have never made a booking from the hotel management system.*/
SELECT g.GuestID, g.FullName, g.Email, g.PhoneNumber
FROM Guests g
LEFT JOIN Bookings b ON g.GuestID = b.GuestID
WHERE b.GuestID IS NULL;


/*15.	Retrieve names of all booked rooms along with the guests who booked them.*/
SELECT r.RoomNumber, r.RoomType, g.FullName
FROM Bookings b
JOIN Rooms r ON b.RoomID = r.RoomID
JOIN Guests g ON b.GuestID = g.GuestID;


/*16.	Retrieve all hotels along with the count of available rooms in each hotel.*/
SELECT h.HotelID, h.Name, COUNT(r.RoomID) AS AvailableRooms
FROM Hotels h
LEFT JOIN Rooms r ON h.HotelID = r.HotelID AND r.Available = 1
GROUP BY h.HotelID, h.Name;

/*17.	Find pairs of rooms from the same hotel that belong to the same room type.*/
SELECT r1.RoomID AS Room1, r2.RoomID AS Room2, r1.HotelID, r1.RoomType
FROM Rooms r1
JOIN Rooms r2 
    ON r1.HotelID = r2.HotelID 
    AND r1.RoomType = r2.RoomType 
    AND r1.RoomID < r2.RoomID;


/*18.	List all possible combinations of hotels and events.*/
SELECT h.Name AS HotelName, e.EventName
FROM Hotels h
CROSS JOIN Events e;


/*19.	Determine the hotel with the highest number of bookings.*/
SELECT TOP 1 h.HotelID, h.Name, COUNT(b.BookingID) AS BookingCount
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
JOIN Bookings b ON r.RoomID = b.RoomID
GROUP BY h.HotelID, h.Name
ORDER BY COUNT(b.BookingID) DESC;
