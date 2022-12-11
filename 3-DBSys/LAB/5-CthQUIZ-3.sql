USE [D'Jewelry Shop]

--1
CREATE TABLE Vendor(
	VendorID CHAR(5) PRIMARY KEY
	CHECK(VendorID LIKE 'VE[0-9][0-9][0-9]'),
	VendorName VARCHAR(50) NOT NULL
	CHECK(LEN(VendorName) > 5),
	VendorVolume VARCHAR(50) NOT NULL
)

--2
BEGIN TRAN
ALTER TABLE Customer
ADD CustomerEmail VARCHAR(50)
COMMIT ROLLBACK

BEGIN TRAN
ALTER TABLE Customer
ADD CONSTRAINT CustomerEmail_Const
CHECK(CustomerEmail LIKE '%@%')
COMMIT ROLLBACK

--3
BEGIN TRAN
INSERT INTO Customer
VALUES('CU011', 'Priocesa', 'Female', 'Kaloa Street', '085678123876')
COMMIT ROLLBACK

--4
--SELECT LOWER(CustomerName) AS CustomerName,
SELECT CustomerName = LOWER(CustomerName),
CustomerPhoneNumber, CustomerAddress
FROM Customer
WHERE CustomerGender LIKE 'Female'

SELECT * FROM Customer

--5
BEGIN TRAN
DELETE Staff
FROM HeaderSalesTransaction hst JOIN Staff s
ON hst.StaffID = s.StaffID
WHERE hst.CustomerID LIKE 'CU006'
COMMIT ROLLBACK

SELECT * FROM Staff