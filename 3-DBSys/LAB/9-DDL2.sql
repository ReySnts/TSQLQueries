DROP DATABASE OOVEO_Salon
USE OOVEO_Salon
--1
CREATE VIEW
	ViewBonus
AS
	SELECT
		BinusId = STUFF(CustomerId, 1, 2, 'BN'),
		CustomerName
	FROM
		MsCustomer
	WHERE
		LEN(CustomerName) > 10
--2
CREATE VIEW
	ViewCustomerData
AS
	SELECT
		[Name] = SUBSTRING(
			CustomerName, 1, CHARINDEX(' ', CustomerName) - 1
		),
		[Address] = CustomerAddress,
		[Phone] = CustomerPhone
	FROM
		MsCustomer
	WHERE
		CHARINDEX(' ', CustomerName) > 0
--3
CREATE VIEW
	ViewTreatment
AS
	SELECT
		TreatmentName,
		TreatmentTypeName,
		Price = 'Rp. ' + CAST(Price AS CHAR)
	FROM
		MsTreatment mt JOIN
		MsTreatmentType mtt ON
		mt.TreatmentTypeId = mtt.TreatmentTypeId
	WHERE
		TreatmentTypeName = 'Hair Treatment' AND
		Price BETWEEN 450000 AND 800000
--4
CREATE VIEW
	ViewTransaction
AS
	SELECT
		StaffName,
		CustomerName,
		TransactionDate = CONVERT(CHAR, TransactionDate, 106),
		PaymentType
	FROM
		HeaderSalonServices hss JOIN
		MsCustomer mc ON
		hss.CustomerId = mc.CustomerId JOIN
		MsStaff ms ON
		hss.StaffId = ms.StaffId
	WHERE
		DAY(TransactionDate) BETWEEN 21 AND 25
		AND PaymentType = 'Credit'
--5
CREATE VIEW
	ViewBonusCustomer
AS
	SELECT
		BonusId = REPLACE(mc.CustomerId, 'CU', 'BN'),
		[Name] = LOWER(
			REVERSE(
				SUBSTRING(
					REVERSE(CustomerName),
					1,
					CHARINDEX(
						' ', REVERSE(CustomerName)
					) - 1
				)
			)
		),
		[Day] = DATENAME(WEEKDAY, TransactionDate),
		TransactionDate = CONVERT(CHAR, TransactionDate, 101)
	FROM
		HeaderSalonServices hss JOIN
		MsCustomer mc ON
		hss.CustomerId = mc.CustomerId
	WHERE
		CHARINDEX(' ', CustomerName) > 0 AND
		SUBSTRING(
			REVERSE(CustomerName),
			1,
			CHARINDEX(
				' ', REVERSE(CustomerName)
			) - 1
		) LIKE '%a%'
--6
CREATE VIEW
	ViewTransactionByLivia
AS
	SELECT
		hss.TransactionId,
		[Date] = CONVERT(CHAR, TransactionDate, 107),
		TreatmentName
	FROM
		DetailSalonServices dss JOIN
		HeaderSalonServices hss ON
		dss.TransactionId = hss.TransactionId JOIN
		MsStaff ms ON
		hss.StaffId = ms.StaffId JOIN
		MsTreatment mt ON
		dss.TreatmentId = mt.TreatmentId
	WHERE
		DAY(TransactionDate) LIKE 21 AND
		StaffName LIKE 'Livia Ashianti'
--7
ALTER VIEW
	ViewCustomerData
AS
	SELECT
		ID = RIGHT(CustomerId, 3),
		[Name] = CustomerName,
		[Address] = CustomerAddress,
		[Phone] = CustomerPhone
	FROM
		MsCustomer
	WHERE
		CHARINDEX(' ', CustomerName) > 0
--8
CREATE VIEW
	ViewCustomer
AS
	SELECT
		CustomerId,
		CustomerName,
		CustomerGender
	FROM
		MsCustomer
INSERT INTO
	ViewCustomer
VALUES
	('CU006', 'Cristian', 'Male')
--9
DELETE
	ViewCustomerData
WHERE
	ID LIKE '005'
SELECT
	*
FROM
	ViewCustomerData
--10
DROP VIEW
	ViewCustomerData