CREATE DATABASE Cafe

USE Cafe

CREATE TABLE Meals
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20),
	Price MONEY
)

CREATE TABLE Tables
(
	Id INT PRIMARY KEY IDENTITY,
	No NVARCHAR(20)
)

CREATE TABLE Orders
(
	Id INT PRIMARY KEY IDENTITY,
	Date DATETIME,
	MealId INT FOREIGN KEY REFERENCES Meals(Id),
	TableId INT FOREIGN KEY REFERENCES Tables(Id)
)

-- Insert data into Meals table
INSERT INTO Meals (Name, Price)
VALUES ('Burger', 8.99),
       ('Pizza', 10.99),
       ('Salad', 6.49);

-- Insert data into Tables table
INSERT INTO Tables (No)
VALUES ('Table 1'),
       ('Table 2'),
       ('Table 3');

-- Insert data into Orders table
INSERT INTO Orders (Date, MealId, TableId)
VALUES ('2024-02-19 12:00:00', 1, 1),  -- Burger ordered at Table 1
       ('2024-02-19 12:15:00', 2, 2),  -- Pizza ordered at Table 2
       ('2024-02-19 12:30:00', 3, 1);  -- Salad ordered at Table 1

-- Bütün masadatalarını yanında o masaya edilmiş sifariş sayı ilə birlikdə select edən query
SELECT * FROM Tables LEFT JOIN (SELECT TableId, COUNT(*) AS Count FROM Orders
GROUP BY TableId) AS MealCounts ON Tables.Id=TableId WHERE TableId IS NOT NULL

-- Bütün yeməkləri o yeməyin sifariş sayı ilə select edən query
SELECT * FROM Meals LEFT JOIN (SELECT MealId, COUNT(*) AS OrderCount FROM Orders
GROUP BY MealId) AS OrderCounts ON Meals.Id=MealId

-- Bütün sirafiş datalarını yanında yeməyin adı ilə select edən query
SELECT * FROM Orders LEFT JOIN (SELECT Id, Name AS MealName FROM Meals) AS MealNames 
ON Orders.MealId=MealNames.Id

-- Bütün sirafiş datalarını yanında yeməyin adı və masanın nömrəsi  ilə select edən query
SELECT * FROM Orders LEFT JOIN (SELECT Id, Name AS MealName FROM Meals) AS MealNames 
ON Orders.MealId=MealNames.Id

-- Bütün masa datalarını yanında o masının sifarişlərinin ümumi məbləği ilə select edən query
SELECT Orders.Id AS OrderId, Meals.Name AS MealName, Tables.No AS TableNumber FROM Orders 
JOIN Meals ON Orders.MealId = Meals.Id
JOIN Tables ON Orders.TableId = Tables.Id;

-- 1-idli masaya verilmis ilk sifarişlə son sifariş arasında neçə saat fərq olduğunu select edən query
SELECT DATEDIFF(hour, MIN(Date), MAX(Date)) AS OrderDifference FROM Orders WHERE TableId=1

-- Ən son 30-dəqədən əvvəl verilmiş sifarişləri select edən query
SELECT * FROM Orders WHERE DATEDIFF(minute, Date, GETDATE())<=30

-- Heç sifariş verməmiş masaları select edən query
SELECT * FROM Tables LEFT JOIN (SELECT TableId FROM Orders
GROUP BY TableId) AS MealCounts ON Tables.Id=TableId WHERE TableId IS NULL

-- Son 60 dəqiqədə heç sifariş verməmiş masaları select edən query
SELECT DISTINCT Tables.Id AS TableId, Tables.No AS TableNo FROM Tables
LEFT JOIN Orders ON Tables.Id=Orders.TableId
WHERE Orders.Id IS NULL OR DATEDIFF(minute, Orders.Date, GETDATE()) >= 60

