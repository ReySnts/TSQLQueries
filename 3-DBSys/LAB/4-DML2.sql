USE FishingMania

--2
SELECT FishName,
Announcement = CONCAT(
	'Price: $',
	FishPrice * 0.5,
	' just for today!'
)
FROM MsFish
WHERE FishName LIKE '%Tuna'

--3
SELECT th.TransactionID,
[Day] = DAY(th.TransactionDate),
[Name] = UPPER(mc.CustomerName)
FROM MsCustomer mc JOIN TransactionHeader th
ON mc.CustomerID = th.CustomerID
WHERE DATEDIFF(DAY, th.TransactionDate, 
'2020-06-23') BETWEEN 0 AND 10

--4
SELECT CustomerName, CustomerAddress = LOWER(CustomerAddress)
FROM MsCustomer
WHERE CustomerAddress LIKE '[0-9][0-9] %'

--5
SELECT mc.CustomerName, th.TransactionDate,
[DayOfWeek] = LEFT(DATENAME(WEEKDAY, th.TransactionDate), 3)
FROM MsCustomer mc JOIN TransactionHeader th
ON mc.CustomerID = th.CustomerID
WHERE YEAR(th.TransactionDate) = 2020
AND MONTH(th.TransactionDate) = 6

--6
SELECT th.TransactionID,
LastName = SUBSTRING(mf.FishermanName,
CHARINDEX(' ', mf.FishermanName) + 1,
LEN(mf.FishermanName) - CHARINDEX(' ', mf.FishermanName)),
th.TransactionDate
FROM MsFisherman mf, TransactionHeader th
WHERE mf.FishermanID = th.FishermanID
AND DATEPART(QUARTER, th.TransactionDate) = 3

--7
SELECT CustomerName,
Email = STUFF(
	CustomerEmail,
	CHARINDEX('@', CustomerEmail) + 1,
	LEN(CustomerEmail) - CHARINDEX('@', CustomerEmail),
	'fmania.com'
)
FROM MsCustomer
WHERE CustomerID IN('CU001', 'CU005', 'CU008')

--8
SELECT mc.CustomerName,
CouponCode = REVERSE(th.TransactionID),
CouponExpiry = CONVERT(
	VARCHAR(18),
	DATEADD(MONTH, 3, th.TransactionDate),
	107
)
FROM MsCustomer mc, TransactionHeader th
WHERE mc.CustomerID = th.CustomerID
AND YEAR(th.TransactionDate) = 2021

--9
SELECT mf.FishName,
[Type] = REPLACE(mft.FishTypeID, 'FT', 'TP')
FROM MsFishType mft, MsFish mf
WHERE mft.FishTypeID = mf.FishTypeID
AND mf.FishName NOT LIKE '%Catfish'
AND mf.FishName NOT LIKE '%Tuna'
AND mf.FishName NOT LIKE '%Bass'
AND mf.FishName NOT LIKE '%Grouper'
AND mf.FishName NOT LIKE '%Marlin'

--10
SELECT CustomerName,
AddressType = RIGHT(
	CustomerAddress,
	CHARINDEX(' ', REVERSE(CustomerAddress)) - 1
)
FROM MsCustomer
WHERE CustomerGender LIKE 'Male'