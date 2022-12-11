DROP DATABASE FishingMania
USE FishingMania
--1
SELECT
	FishermanID,
	FishermanName
FROM
	MsFisherman
WHERE
	FishermanID IN('FS001', 'FS003', 'FS011')
--2
SELECT
	FishName,
	FishPrice
FROM
	MsFish
WHERE
	FishTypeID IN(
		SELECT
			FishTypeID
		FROM
			MsFishType
		WHERE
			FishTypeName NOT IN('Marlin', 'Grouper', 'Bass')
	)
--3
SELECT
	CustomerName,
	CustomerEmail
FROM
	MsCustomer
WHERE
	CustomerID NOT IN(
		SELECT
			CustomerID
		FROM
			TransactionHeader
	) AND CustomerGender = 'Male'
--4
SELECT
	FishTypeName,
	FishName,
	FishPrice
FROM
	MsFish mf JOIN
	MsFishType mft ON
	mf.FishTypeID = mft.FishTypeID
WHERE
	FishID IN(
		SELECT
			FishID
		FROM
			TransactionDetail td JOIN
			TransactionHeader th ON
			td.TransactionID = th.TransactionID JOIN
			MsCustomer mc ON
			th.CustomerID = mc.CustomerID
		WHERE
			CustomerGender = 'Female' AND
			DATENAME(QUARTER, TransactionDate) = 2 AND
			YEAR(TransactionDate) = 2020
	)
--5
SELECT
	CustomerName,
	[Transaction Date] = CONVERT(CHAR, TransactionDate, 106)
FROM
	TransactionHeader th JOIN
	MsCustomer mc ON
	th.CustomerID = mc.CustomerID
WHERE
	EXISTS(
		SELECT
			*
		FROM
			TransactionDetail td JOIN
			MsFish mf ON
			td.FishID = mf.FishID
		WHERE
			th.TransactionID = td.TransactionID AND
			FishPrice > 35
	)
--6
SELECT
	CustomerName,
	CustomerGender,
	CustomerEmail
FROM
	MsCustomer mc
WHERE
	EXISTS(
		SELECT
			*
		FROM
			TransactionHeader th JOIN
			MsFisherman mf ON
			th.FishermanID = mf.FishermanID
		WHERE
			mc.CustomerID = th.CustomerID AND
			FishermanGender = 'Female' AND
			LEFT(FishermanName, 1)
			IN('L', 'R')
	)
--7
SELECT
	CustomerID,
	CustomerName
FROM
	MsCustomer mc
WHERE
	CustomerGender = 'Male' AND
	CustomerID IN(
		SELECT
			CustomerID
		FROM
			TransactionHeader th
		WHERE
			NOT EXISTS(
				SELECT
					*
				FROM
					TransactionDetail td JOIN
					MsFish mf ON
					td.FishID = mf.FishID JOIN
					MsFishType mft ON
					mf.FishTypeID = mft.FishTypeID
				WHERE
					FishTypeName = 'Tuna' AND
					th.TransactionID = td.TransactionID
			)
	)
--8
SELECT
	FishName,
	FishTypeName,
	FishPrice
FROM
	MsFish mf JOIN
	MsFishType mft ON
	mf.FishTypeID = mft.FishTypeID, (
		SELECT
			avgPrice = AVG(FishPrice)
		FROM
			MsFish
	) alias_subquery
WHERE
	FishPrice > alias_subquery.avgPrice
--9
SELECT
	FishName,
	FishPrice
FROM
	MsFish, (
		SELECT
			maxPrice = MAX(FishPrice),
			minPrice = MIN(FishPrice)
		FROM
			MsFish
	) alias_subquery
WHERE
	FishPrice IN(alias_subquery.maxPrice, alias_subquery.minPrice)
--10
SELECT
	CustomerName,
	CustomerEmail--,
	--[Fish Type Variant] = MIN()
FROM
	TransactionHeader th JOIN
	MsCustomer mc ON
	th.CustomerID = mc.CustomerID, (
		SELECT
			FishTypeID,
			FishTypeTotal = COUNT(FishTypeID)
		FROM
			TransactionDetail td JOIN
			MsFish mf ON
			td.FishID = mf.FishID
		GROUP BY
			FishTypeID
	) alias_subquery
--GROUP BY
--	CustomerName,
--	CustomerEmail