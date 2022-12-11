DROP DATABASE FishingMania
USE FishingMania
--1
SELECT
	[Maximum Price] = MAX(FishPrice),
	[Minimum Price] = MIN(FishPrice),
	[Average Price] = ROUND(
		AVG(FishPrice), 1
	)
FROM
	MsFish
--2
SELECT
	FishTypeName,
	[Average Price] = CONCAT(
		'$',
		ROUND(
			AVG(FishPrice), 1
		)
	)
FROM
	MsFish mf JOIN
	MsFishType mft ON
	mf.FishTypeID = mft.FishTypeID
GROUP BY
	FishTypeName
--3
SELECT
	FishermanName,
	[Number of Transaction] = COUNT(TransactionID)
FROM
	TransactionHeader th JOIN
	MsFisherman mf ON
	th.FishermanID = mf.FishermanID
WHERE
	LEFT(FishermanName, 1)
	NOT IN('C', 'D')
GROUP BY
	FishermanName
--4
SELECT
	[Month] = MONTH(TransactionDate),
	[Total Transaction per Month] = COUNT(TransactionID)
FROM
	TransactionHeader
WHERE
	YEAR(TransactionDate) = 2020
GROUP BY
	MONTH(TransactionDate)
--5
SELECT
	FishTypeName,
	[Total Fish Variant] = COUNT(FishID)
FROM
	MsFish mf JOIN
	MsFishType mft ON
	mf.FishTypeID = mft.FishTypeID
GROUP BY
	FishTypeName
ORDER BY
	COUNT(FishID) DESC
--6
SELECT
	[Month] = MONTH(TransactionDate),
	[Total Monthly Revenue] = CONCAT(
		'$', SUM(
			FishPrice * CAST(Quantity AS FLOAT)
		)
	)
FROM
	TransactionHeader th JOIN
	TransactionDetail td ON
	th.TransactionID = td.TransactionID JOIN
	MsFish mf ON
	td.FishID = mf.FishID
WHERE
	YEAR(TransactionDate) = 2020
GROUP BY
	MONTH(TransactionDate)
HAVING
	SUM(
		FishPrice * CAST(Quantity AS FLOAT)
	) >= 600
--7
SELECT
	ID = REPLACE(mft.FishTypeID, 'FT', 'Fish Type '),
	FishTypeName,
	[Total Transaction per Type] = CONCAT(
		COUNT(DISTINCT TransactionID), ' Transaction'
	)
FROM
	TransactionDetail td JOIN
	MsFish mf ON
	td.FishID = mf.FishID JOIN
	MsFishType mft ON
	mf.FishTypeID = mft.FishTypeID
GROUP BY
	REPLACE(mft.FishTypeID, 'FT', 'Fish Type '),
	FishTypeName
HAVING
	COUNT(DISTINCT TransactionID) > 4
ORDER BY
	CONCAT(
		COUNT(DISTINCT TransactionID), ' Transaction'
	) DESC
--8
SELECT
	CustomerName,
	[Year] = YEAR(TransactionDate),
	FishTypeID,
	[Total Yearly Spending per Type] = SUM(FishPrice * Quantity)
FROM
	TransactionHeader th JOIN
	MsCustomer mc ON
	th.CustomerID = mc.CustomerID JOIN
	TransactionDetail td ON
	th.TransactionID = td.TransactionID JOIN
	MsFish mf ON
	td.FishID = mf.FishID
GROUP BY
	CustomerName,
	YEAR(TransactionDate),
	FishTypeID
HAVING
	SUM(FishPrice * Quantity) >= 500
--9
SELECT TOP(5)
	FishName,
	Revenue = SUM(FishPrice * Quantity)
FROM
	TransactionDetail td JOIN
	MsFish mf ON
	td.FishID = mf.FishID
GROUP BY
	FishName
ORDER BY
	SUM(FishPrice * Quantity) DESC
--10
SELECT
	TransactionDate,
	CustomerName,
	[Total Price] = SUM(FishPrice * Quantity)
FROM
	TransactionHeader th JOIN
	MsCustomer mc ON
	th.CustomerID = mc.CustomerID JOIN
	TransactionDetail td ON
	th.TransactionID = td.TransactionID JOIN
	MsFish mf ON
	td.FishID = mf.FishID
WHERE
	DAY(TransactionDate) > 10 AND
	MONTH(TransactionDate) = 6 AND
	YEAR(TransactionDate) = 2020
GROUP BY
	TransactionDate,
	CustomerName
ORDER BY
	TransactionDate ASC