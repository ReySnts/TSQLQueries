USE JphonE
-- NIM: 2401960435.
-- Nama: Reynaldy Sentosa.

--No. 1
BEGIN TRAN
CREATE TABLE MsCustomer(
	CustomerId CHAR(5) PRIMARY KEY
	CHECK(CustomerId LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(25) NOT NULL
	CHECK(CHARINDEX(' ', CustomerName) > 1
	AND CHARINDEX(' ', REVERSE(CustomerName)) > 1),
	CustomerEmail VARCHAR(35) NOT NULL
)

INSERT INTO MsCustomer
VALUES('CU001', 'Reynaldy S', 'reynaldy@gmail.com')

SELECT * FROM MsCustomer

COMMIT ROLLBACK

--No. 2
BEGIN TRAN
ALTER TABLE MsColor
ADD ColorHex VARCHAR(10)
COMMIT ROLLBACK

BEGIN TRAN
ALTER TABLE MsColor
ADD CONSTRAINT ColorHex_Const
CHECK(LEN(ColorHex) = 7)
COMMIT ROLLBACK

--No. 3
BEGIN TRAN
INSERT INTO MsPhone
VALUES('PH006', 'CO004', 'JphonE Air', 1335000)
COMMIT ROLLBACK

SELECT * FROM MsPhone

--No. 4
SELECT StaffID, StaffName, StaffEmail
FROM MsStaff
WHERE StaffName LIKE '% %'

--No. 5
BEGIN TRAN
DELETE MsPhone
FROM MsColor mc JOIN MsPhone mp
ON mc.ColorId = mp.ColorId
WHERE mc.ColorName IN('Rose', 'Gold')
COMMIT ROLLBACK