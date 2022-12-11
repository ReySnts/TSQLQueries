--2401960435 - Reynaldy Sentosa.
USE KroffleZ
--1
SELECT
	CustomerName,
	CustomerGender,
	CustomerEmail
FROM
	MsCustomer
WHERE
	LEFT(CustomerName, 1) LIKE 'M'
--2
SELECT
	StaffName,
	TransactionDate
FROM
	TransactionHeader th JOIN
	MsStaff ms ON
	th.StaffID = ms.StaffID
WHERE
	DATENAME(QUARTER, TransactionDate) = 1
--3
SELECT
	[First Name] = LEFT(
		CustomerName,
		CHARINDEX(' ', CustomerName) - 1
	),
	[Total Transaction] = COUNT(TransactionID)
FROM
	TransactionHeader th JOIN
	MsCustomer mc ON
	th.CustomerID = mc.CustomerID
WHERE
	CustomerGender = 'Male'
GROUP BY
	LEFT(
		CustomerName,
		CHARINDEX(' ', CustomerName) - 1
	)
--4
SELECT
	ToppingName,
	[Total Transaction] = COUNT(TransactionID),
	[Average Croffle Price] = AVG(CrofflePrice)
FROM
	TransactionDetail td JOIN
	MsCroffle mc ON
	td.CroffleID = mc.CroffleID JOIN
	MsTopping mt ON
	mc.ToppingID = mt.ToppingID
WHERE
	CroffleName LIKE '%berry%'
GROUP BY
	ToppingName
HAVING
	AVG(CrofflePrice) > 200
UNION
SELECT
	ToppingName,
	[Total Transaction] = COUNT(TransactionID),
	[Average Croffle Price] = AVG(CrofflePrice)
FROM
	TransactionDetail td JOIN
	MsCroffle mc ON
	td.CroffleID = mc.CroffleID JOIN
	MsTopping mt ON
	mc.ToppingID = mt.ToppingID
WHERE
	CroffleName LIKE '%pinky%'
GROUP BY
	ToppingName
HAVING
	AVG(CrofflePrice) > 200
--5
SELECT
	[Customer ID] = REPLACE(CustomerID, 'CU', 'Customer '),
	CustomerName,
	CustomerGender,
	CustomerEmail
FROM
	MsCustomer
WHERE
	CustomerID IN(
		SELECT
			CustomerID
		FROM
			TransactionHeader th JOIN
			TransactionDetail td ON
			th.TransactionID = td.TransactionID JOIN
			MsCroffle mc ON
			td.CroffleID = mc.CroffleID
		WHERE
			CroffleStock > 100 AND
			CroffleName LIKE '% % %'
	)
--6
SELECT
	CustomerName,
	[Phone Number] = STUFF(
		CustomerPhoneNumber,
		CHARINDEX('0', CustomerPhoneNumber),
		1,
		'+62'
	)
FROM
	TransactionHeader th JOIN
	MsCustomer mc ON
	th.CustomerID = mc.CustomerID JOIN
	MsStaff ms ON
	th.StaffID = ms.StaffID, (
		SELECT
			averageSalary = AVG(StaffSalary)
		FROM
			MsStaff
	) alias_subquery
WHERE
	StaffSalary > alias_subquery.averageSalary AND
	DAY(TransactionDate) = 25
--7
GO
CREATE VIEW
	[View Strawberry Croffle]
AS
	SELECT
		CroffleName,
		CrofflePrice,
		Stock = CAST(CroffleStock AS VARCHAR) + ' croffle(s)',
		ToppingName
	FROM
		MsCroffle mc JOIN
		MsTopping mt ON
		mc.ToppingID = mt.ToppingID
	WHERE
		ToppingName LIKE 'Strawberry%'
--8
GO
CREATE VIEW
	[Total Purchase Croffle]
AS
	SELECT
		ToppingName,
		[Total Purchase] = CONCAT(
			SUM(Quantity),
			' croffle(s)'
		)
	FROM
		TransactionDetail td JOIN
		MsCroffle mc ON
		td.CroffleID = mc.CroffleID JOIN
		MsTopping mt ON
		mc.ToppingID = mt.ToppingID
	WHERE
		ToppingName LIKE '%c%' AND
		CrofflePrice > 225
	GROUP BY
		ToppingName
--9
GO
SELECT 
	*
FROM 
	MsStaff
BEGIN TRAN
ALTER TABLE
	MsStaff
ADD
	StaffEmail VARCHAR(50)
ALTER TABLE
	MsStaff
ADD CONSTRAINT
	staffEmail_const
	CHECK(StaffEmail LIKE '%krofflez.com')
ROLLBACK
COMMIT
--10
SELECT
	*
FROM
	MsCustomer
BEGIN TRAN
DELETE
	MsCustomer
WHERE
	CustomerID IN(
		SELECT
			CustomerID
		FROM
			TransactionHeader th JOIN
			MsStaff ms ON
			th.StaffID = ms.StaffID
		WHERE
			StaffSalary > 1000 AND
			RIGHT(ms.StaffID, 3) % 2 = 0
	)
ROLLBACK
COMMIT