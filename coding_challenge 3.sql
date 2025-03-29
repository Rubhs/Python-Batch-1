IF NOT EXISTS (SELECT * FROM sys.databases WHERE name='PetCare')
	CREATE DATABASE PetCare;
	USE PetCare;

/*
USE HotelManagement;
DROP DATABASE PetCare;*/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Pets')
	CREATE TABLE Pets (PetID INT PRIMARY KEY,
					   Name VARCHAR(50) NOT NULL,
					   Age INT NOT NULL,
					   Breed VARCHAR(50) NOT NULL,
					   Type VARCHAR(50) NOT NULL,
					   OwnerNAme VARCHAR(50),
					   OwnerID INT,
					   AvailableForAdoption VARCHAR(10) NOT NULL CHECK (AvailableForAdoption IN ('YES','NO')));
--DROP TABLE Pets;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Shelters')
	CREATE TABLE Shelters ( ShelterID INT PRIMARY KEY,
							Name VARCHAR(50) NOT NULL UNIQUE,
							Location VARCHAR(100) NOT NULL,
							PetID INT,
							FOREIGN KEY(PetID) REFERENCES Pets(PetID));
--DROP TABLE Shelters;


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Donations')
	CREATE TABLE Donations( DonationID INT PRIMARY KEY, 
							DonorName VARCHAR(50) NOT NULL, 
							DonationType VARCHAR(50) NOT NULL, 
							DonationAmount DECIMAL(10,2) , 
							DonationItem VARCHAR(100) , 
							DonationDate DATE,
							ShelterID INT,
							FOREIGN KEY(ShelterID) REFERENCES Shelters(ShelterID) ON DELETE CASCADE );
--DROP TABLE Donations;
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='AdoptionEvents')
	CREATE TABLE AdoptionEvents (EventID INT PRIMARY KEY, 
								 EventName VARCHAR(50) NOT NULL, 
								 EventDate DATE NOT NULL, 
								 Location VARCHAR(100) NOT NULL);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Participants')
	CREATE TABLE Participants (ParticipantID INT PRIMARY KEY, 
							   ParticipantName VARCHAR(50) NOT NULL, 
							   ParticipantType VARCHAR(50) NOT NULL CHECK (ParticipantType IN ('Adopter', 'Volunteer', 'Sponsor')), 
							   EventID INT NOT NULL,
							   FOREIGN KEY(EventID) REFERENCES AdoptionEvents(EventID) ON DELETE CASCADE) ;

INSERT INTO Pets (PetID, Name, Age, Breed, Type,OwnerNAme,OwnerID, AvailableForAdoption) VALUES
				 (007,'Buddy', 3, 'Golden Retriever', 'Dog','John',98, 'YES'),
				 (008,'Whiskers', 2, 'Siamese', 'Cat',Null,Null, 'YES'),
				 (009,'Charlie', 4, 'Labrador', 'Dog','Rahul',96 , 'NO');

SELECT * FROM Pets;

INSERT INTO Shelters (ShelterID, Name, Location,PetID) VALUES
					 (55,'Happy Paws Shelter', '123 Main St, Cityville',007),
					 (57,'Safe Haven Shelter', '456 Elm St, Townsville',008);
SELECT * FROM Shelters;

INSERT INTO Donations (DonationID, DonorName, DonationType, DonationAmount, DonationItem, DonationDate, ShelterID) VALUES
    (111, 'John Doe', 'Money', 100.00, NULL, '2025-03-01', 55),
    (222, 'Jane Smith', 'Item', 500.00, 'Dog Food', '2025-03-05', 57),
    (333, 'Sam Smith', 'Money', 275.00, NULL, '2024-03-05', 57);

SELECT * FROM Donations;

INSERT INTO AdoptionEvents (EventID, EventName, EventDate, Location) VALUES
						   (123,'Spring Adoption Fair', '2025-04-15', 'City Park'),
						   (456,'Summer Pet Expo', '2025-06-10', 'Convention Center');
SELECT * FROM AdoptionEvents;


INSERT INTO Participants (ParticipantID, ParticipantName, ParticipantType, EventID) VALUES
						 (80,'Alice Brown', 'Adopter', 123),
						 (70,'Bob White', 'Volunteer', 456);
SELECT * FROM Participants;

/*
3.	Retrieve Available Pets:
o	Write an SQL query to list pets available for adoption.
o	Output should include the pet's Name, Age, Breed, and Type
*/
SELECT Name, Age, Breed, Type FROM Pets WHERE AvailableForAdoption='YES';

/*4.	Retrieve Event Participants:
o	Write an SQL query to list participant names and types for a specific event based on EventID.
*/
--SELECT P.ParticipantName, P.ParticipantType FROM Participants P JOIN ON 
SELECT ParticipantName, ParticipantType FROM Participants WHERE EventID=456;

/*5.	Update Shelter Information (Stored Procedure):
o	Create a stored procedure to update a shelter’s name and location.
o	The procedure should take ShelterID, NewName, and NewLocation as parameters.
*/
GO
CREATE PROCEDURE UpdateShelter
	@oldName VARCHAR(50) ,
	@newName VARCHAR(50) ,
	@location VARCHAR(100),
	@shelterid INT
AS 
	UPDATE Shelters SET ShelterID=@shelterid, Name=@newName,Location=@location WHERE Name=@oldName
EXEC UpdateShelter @oldName='Good Will Shelter', @location='456 Nehru St, Chennai', @newName='Sunshine Angles', @shelterid='57'
--DROP PROCEDURE IF EXISTS UpdateShelter;


/* 6.	Calculate Shelter Donations:
o	Write an SQL query to calculate the total donation amount per shelter.
o	The output should include Shelter Name and Total Donation Amount.
*/
SELECT s.Name,SUM(d.DonationAmount) AS TotalDonation FROM Shelters s JOIN Donations d ON s.ShelterID=d.ShelterID
GROUP BY s.Name ;

/*7.	Retrieve Pets Without Owners:
o	Write an SQL query to list all pets that do not have an owner (OwnerID IS NULL).
*/
SELECT PetID, Name FROM Pets WHERE OwnerID IS NULL;

/*8.	Monthly Donation Summary:
o	Write an SQL query to retrieve total donations per month and year.
*/
SELECT MONTH(DonationDate) AS DonationMonth, YEAR(DonationDate) AS DonationYear,SUM(DonationAmount) AS TotalDonation FROM Donations
WHERE DonationAmount IS NOT NULL GROUP BY MONTH(DonationDate), YEAR(DonationDate)
ORDER BY DonationYear DESC, DonationMonth DESC ;

/*9.	Filter Pets by Age:
o	Retrieve distinct pet breeds where pets are aged between 1 and 3 years or older than 5 years.
*/
SELECT DISTINCT Breed FROM Pets WHERE (Age BETWEEN 1 AND 3) OR AGE > 5;

/*10.	Pets and Their Shelters:
•	List all pets and their respective shelters where pets are available for adoption.
*/
SELECT P.Name,S.Name FROM Pets P JOIN Shelters S ON P.PetID=S.PetID WHERE P.AvailableForAdoption='YES'; 

/*11.	Count Event Participants by City:
•	Find the total number of participants in adoption events held in a specific city (e.g., Mumbai).
*/
SELECT A.Location,COUNT(P.ParticipantID) FROM Participants P 
JOIN AdoptionEvents A ON P.EventID=A.EventID 
WHERE A.Location='City Park' GROUP BY A.Location;

/*
12.	Unique Breeds of Young Pets:
•	Retrieve unique pet breeds for pets aged between 1 and 5 years.*/
SELECT DISTINCT Breed FROM Pets WHERE Age BETWEEN 1 AND 5;

/*13.	Find Pets Not Yet Adopted:
•	Retrieve a list of pets that have not been adopted.*/
SELECT Name, PetID, Breed FROM Pets WHERE AvailableForAdoption='NO';

/*14.	Retrieve Adopted Pets and Adopters:
•	Fetch the names of adopted pets along with their adopter’s name.*/
SELECT NAME,OwnerNAme FROM Pets WHERE OwnerNAme IS NOT NULL;

/*15.	Count Available Pets in Shelters:
•	List all shelters along with the count of pets currently available for adoption in each shelter.*/
SELECT s.Name , COUNT(p.PetID) AS PetsCount FROM Shelters s JOIN Pets p ON s.PetID = p.PetID  
WHERE p.AvailableForAdoption = 'YES' GROUP BY s.Name;


/*16.	Find Matching Pet Pairs in Shelters:
•	List pairs of pets from the same shelter that have the same breed.*/
SELECT P1.PetID AS Pet1_ID, P1.Name AS Pet1_Name, 
       P2.PetID AS Pet2_ID, P2.Name AS Pet2_Name, 
       S.Name AS ShelterName, P1.Breed
FROM Pets P1
JOIN Pets P2 ON P1.Breed = P2.Breed 
            AND P1.PetID < P2.PetID  
JOIN Shelters S ON P1.PetID = S.PetID 
               AND P2.PetID = S.PetID; 


/*17.	Find All Shelter-Event Combinations:
•	Retrieve all possible combinations of shelters and adoption events.*/
SELECT s.Name AS ShelterName, e.EventName AS AdoptionEvent FROM Shelters s CROSS JOIN AdoptionEvents e;


/*18.	Identify the Most Successful Shelter:
•	Determine the shelter that has the highest number of adopted pets.*/
SELECT TOP 1 s.Name AS ShelterName, COUNT(p.PetID) AS AdoptedPetsCount FROM Shelters s
JOIN Pets p ON s.PetID = p.PetID WHERE p.AvailableForAdoption = 'NO'
GROUP BY s.Name ORDER BY COUNT(p.PetID) DESC ;


/*19.	Trigger for Adoption Status Update:
•	Create a database trigger that updates a pet’s AvailableForAdoption status when it is adopted.*/
GO
CREATE TRIGGER trg_UpdateAdoptionStatus
ON Pets
AFTER UPDATE
AS
    SET NOCOUNT ON;
    UPDATE Pets
    SET AvailableForAdoption = 'NO'
    FROM inserted i
    WHERE Pets.PetID = i.PetID AND i.OwnerID IS NOT NULL;

UPDATE Pets SET OwnerID = 100  WHERE PetID = 007; 


/*20.	Data Integrity Check:
•	Ensure that a pet cannot be adopted twice using a constraint or validation trigger.
*/
GO
CREATE TRIGGER trg_PreventMultipleAdoptions
ON Pets
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Prevent changing OwnerID if the pet is already adopted
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON i.PetID = d.PetID
        WHERE d.OwnerID IS NOT NULL AND i.OwnerID <> d.OwnerID
    )
    BEGIN
        THROW 50000, 'This pet has already been adopted and cannot be reassigned.', 1;
        ROLLBACK TRANSACTION;
    END;
END;

UPDATE Pets SET OwnerID = 102 WHERE PetID = 008;


