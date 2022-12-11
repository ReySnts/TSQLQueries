DROP DATABASE OOVEO_Salon
USE OOVEO_Salon
--1
SELECT
	TreatmentId,
	TreatmentName
FROM
	MsTreatment
WHERE
	TreatmentId IN('TM001', 'TM002')
--2
SELECT
	TreatmentName,
	Price
FROM
	MsTreatment
WHERE
	TreatmentTypeId IN(
		SELECT
			TreatmentTypeId
		FROM
			MsTreatmentType
		WHERE
			TreatmentTypeName NOT IN('Hair Treatment', 'Message / Spa')
	)
--3
SELECT
	CustomerName,
	CustomerPhone,
	CustomerAddress
FROM
	MsCustomer
WHERE
	LEN(CustomerName) > 8 AND
	CustomerId IN(
		SELECT
			CustomerId
		FROM
			HeaderSalonServices
		WHERE
			DATENAME(WEEKDAY, TransactionDate) = 'Friday'
	)
--4
SELECT
	TreatmentTypeName,
	TreatmentName,
	Price
FROM
	MsTreatment mt JOIN
	MsTreatmentType mtt ON
	mt.TreatmentTypeId = mtt.TreatmentTypeId
WHERE
	TreatmentId IN(
		SELECT
			TreatmentId
		FROM
			DetailSalonServices dss JOIN
			HeaderSalonServices hss ON
			dss.TransactionId = hss.TransactionId JOIN
			MsCustomer mc ON
			hss.CustomerId = mc.CustomerId
		WHERE
			CustomerName LIKE '%Putra%' AND
			DAY(TransactionDate) = 22
	)
--5
SELECT
	StaffName,
	CustomerName,
	TransactionDate = CONVERT(CHAR, TransactionDate, 107)
FROM
	HeaderSalonServices hss JOIN
	MsCustomer mc ON
	hss.CustomerId = mc.CustomerId JOIN
	MsStaff ms ON
	hss.StaffId = ms.StaffId
WHERE
	EXISTS(
		SELECT
			*
		FROM
			DetailSalonServices dss
		WHERE
			CAST(
				RIGHT(TreatmentId, 1) AS INT
			) % 2 = 0 AND
			dss.TransactionId = hss.TransactionId
	)
--6
SELECT
	CustomerName,
	CustomerPhone,
	CustomerAddress
FROM
	MsCustomer mc
WHERE
	EXISTS(
		SELECT
			*
		FROM
			HeaderSalonServices hss JOIN
			MsStaff ms ON
			hss.StaffId = ms.StaffId
		WHERE
			LEN(StaffName) % 2 = 1 AND
			hss.CustomerId = mc.CustomerId
	)
----7
--SELECT
--	ID = RIGHT(StaffId, 3),
--	[Name] = SUBSTRING(
--		StaffName,
--		CHARINDEX(' ', StaffName) + 1,
		
--	)
--FROM
--	MsStaff
--WHERE
--	CHARINDEX(' ', StaffName) > 0 AND
--	CHARINDEX(' ', StaffName) <
--	LEN(StaffName) -
--	CHARINDEX(
--		' ', REVERSE(StaffName)
--	) + 1 AND
--	EXISTS(
		
--	)
--8
SELECT
	TreatmentTypeName,
	TreatmentName,
	Price
FROM
	MsTreatment mt JOIN
	MsTreatmentType mtt ON
	mt.TreatmentTypeId = mtt.TreatmentTypeId, (
		SELECT
			avgPrice = AVG(Price)
		FROM
			MsTreatment
	) alias_subquery
WHERE
	Price > alias_subquery.avgPrice
--9
SELECT
	StaffName,
	StaffPosition,
	StaffSalary
FROM
	MsStaff, (
		SELECT
			maxSalary = MAX(StaffSalary),
			minSalary = MIN(StaffSalary)
		FROM
			MsStaff
	) alias_subquery
WHERE
	StaffSalary IN(
		alias_subquery.maxSalary,
		alias_subquery.minSalary
	)
--10
SELECT
	CustomerName,
	CustomerPhone,
	CustomerAddress,
	[Count Treatment] = a.totalTreatment
FROM
	HeaderSalonServices hss JOIN
	MsCustomer mc ON
	hss.CustomerId = mc.CustomerId, (
		SELECT
			TransactionId,
			totalTreatment = COUNT(TreatmentId)
		FROM
			DetailSalonServices
		GROUP BY
			TransactionId
	) a,
	(
		SELECT
			maxTreatment = MAX(a.totalTreatment)
		FROM
			(
				SELECT
					TransactionId,
					totalTreatment = COUNT(TreatmentId)
				FROM
					DetailSalonServices
				GROUP BY
					TransactionId
			) a
	) b
WHERE
	a.totalTreatment = b.maxTreatment AND
	hss.TransactionId = a.TransactionId