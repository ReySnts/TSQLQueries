DROP DATABASE OOVEO_Salon
USE OOVEO_Salon
--1
SELECT
	[Maximum Price] = CAST(
		MAX(Price) AS
		NUMERIC(18, 2)
	),
	[Minimum Price] = CAST(
		MIN(Price) AS
		NUMERIC(18, 2)
	),
	[Average Price] = CAST(
		ROUND(
			CAST(
				AVG(Price) AS NUMERIC
			), 2
		) AS
		NUMERIC(18, 2)
	)
FROM
	MsTreatment
--2
SELECT
	StaffPosition,
	Gender = LEFT(StaffGender, 1),
	[Average Salary] = CONCAT(
		'Rp.',
		CAST(
			AVG(StaffSalary) AS
			NUMERIC(18, 2)
		)
	)
FROM
	MsStaff
GROUP BY
	StaffPosition,
	LEFT(StaffGender, 1)
--3
SELECT
	TransactionDate = CONVERT(
		CHAR(12), TransactionDate, 107
	),
	[Total Transaction per Day] = COUNT(TransactionId)
FROM
	HeaderSalonServices
GROUP BY
	TransactionDate
--4
SELECT
	CustomerGender = UPPER(CustomerGender),
	[Total Transaction] = COUNT(TransactionId)
FROM
	HeaderSalonServices hss JOIN
	MsCustomer mc ON
	hss.CustomerId = mc.CustomerId
GROUP BY
	CustomerGender
--5
SELECT
	TreatmentTypeName,
	[Total Transaction] = COUNT(TransactionId)
FROM
	DetailSalonServices dss JOIN
	MsTreatment mt ON
	dss.TreatmentId = mt.TreatmentId JOIN
	MsTreatmentType mtt ON
	mt.TreatmentTypeId = mtt.TreatmentTypeId
GROUP BY
	TreatmentTypeName
ORDER BY
	COUNT(TransactionId) DESC
--6
SELECT
	[Date] = CONVERT(
		CHAR(11), TransactionDate, 106
	),
	[Revenue per Day] = (
		CONCAT(
			'Rp. ', CAST(
				SUM(Price) AS
				NUMERIC(18, 2)
			)
		)
	)
FROM
	DetailSalonServices dss JOIN
	HeaderSalonServices hss ON
	dss.TransactionId = hss.TransactionId JOIN
	MsTreatment mt ON
	dss.TreatmentId = mt.TreatmentId
GROUP BY
	CONVERT(
		CHAR(11), TransactionDate, 106
	)
HAVING
	CAST(
		SUM(Price) AS
		NUMERIC(18, 2)
	) BETWEEN 1000000 AND 5000000
--7
SELECT
	ID = REPLACE(mtt.TreatmentTypeId, 'TT0', 'Treatment Type '),
	TreatmentTypeName,
	[Total Treatment per Type] = CAST(
		COUNT(TreatmentId) AS VARCHAR
	) + ' Treatment'
FROM
	MsTreatment mt JOIN
	MsTreatmentType mtt ON
	mt.TreatmentTypeId = mtt.TreatmentTypeId
GROUP BY
	REPLACE(mtt.TreatmentTypeId, 'TT0', 'Treatment Type '),
	TreatmentTypeName
HAVING
	COUNT(TreatmentId) > 5
ORDER BY
	COUNT(TreatmentId) DESC
--8
SELECT
	StaffName = LEFT(
		StaffName, CHARINDEX(' ', StaffName) - 1
	),
	hss.TransactionId,
	[Total Treatment per Transaction] = COUNT(TreatmentId)
FROM
	DetailSalonServices dss JOIN
	HeaderSalonServices hss ON
	dss.TransactionId = hss.TransactionId JOIN
	MsStaff ms ON
	hss.StaffId = ms.StaffId
GROUP BY
	LEFT(
		StaffName, CHARINDEX(' ', StaffName) - 1
	),
	hss.TransactionId
--9
SELECT
	TransactionDate,
	CustomerName,
	TreatmentName,
	Price
FROM
	DetailSalonServices dss JOIN
	HeaderSalonServices hss ON
	dss.TransactionId = hss.TransactionId JOIN
	MsCustomer mc ON
	hss.CustomerId = mc.CustomerId JOIN
	MsStaff ms ON
	hss.StaffId = ms.StaffId JOIN
	MsTreatment mt ON
	dss.TreatmentId = mt.TreatmentId
WHERE
	DATENAME(WEEKDAY, TransactionDate) = 'Thursday' AND
	StaffName LIKE '%Ryan%'
ORDER BY
	TransactionDate,
	CustomerName ASC
--10
SELECT
	TransactionDate,
	CustomerName,
	TotalPrice = SUM(Price)
FROM
	DetailSalonServices dss JOIN
	HeaderSalonServices hss ON
	dss.TransactionId = hss.TransactionId JOIN
	MsCustomer mc ON
	hss.CustomerId = mc.CustomerId JOIN
	MsTreatment mt ON
	dss.TreatmentId = mt.TreatmentId
WHERE
	DAY(TransactionDate) > 20
GROUP BY
	TransactionDate,
	CustomerName
ORDER BY
	TransactionDate ASC