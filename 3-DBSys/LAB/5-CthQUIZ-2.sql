USE RamenShop

--1
BEGIN TRAN
CREATE TABLE Branch(
	BranchID CHAR(5) PRIMARY KEY
	CHECK(BranchID LIKE 'BR[0-9][0-9][0-9]'),
	BranchAddress VARCHAR(50) NOT NULL
	CHECK(BranchAddress LIKE '% Street'),
	BranchPhone VARCHAR(15) NOT NULL,
	BranchOwner VARCHAR(50) NOT NULL
)
COMMIT ROLLBACK

SELECT * FROM Branch

--2
BEGIN TRAN
ALTER TABLE Staff
ADD StaffPhone VARCHAR(15)
COMMIT ROLLBACK

SELECT * FROM Staff

BEGIN TRAN
ALTER TABLE Staff
ADD CONSTRAINT StaffPhone_Const
CHECK(StaffPhone LIKE '+68%')
COMMIT ROLLBACK

--3
BEGIN TRAN
INSERT INTO Staff
VALUES('ST006', 'Martin Gunawan', 'Male', 
'05-17-1989', 'martin-9809@yopmail.com')
COMMIT ROLLBACK

--4
SELECT StaffID, StaffName, StaffGender
FROM Staff
WHERE MONTH(StaffDOB) = 5

--5
-- TR014
BEGIN TRAN
UPDATE Ramen
SET RamenPrice += 10000
FROM TransactionDetail td JOIN Ramen r
ON td.RamenID = r.RamenID
WHERE RIGHT(td.TransactionID, 3) % 2 = 0
COMMIT ROLLBACK

SELECT * FROM Ramen