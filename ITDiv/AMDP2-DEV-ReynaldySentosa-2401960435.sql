USE Netflox;

--1
SELECT
	CONCAT
	(
		FirstName,
		' ',
		LastName
	) [Name],
	CONCAT
	(
		[Address],
		', ',
		[City]
	) CustAddress
FROM
	MsCustomer
ORDER BY
	DOB;

--2
SELECT
	CONCAT
	(
		RIGHT
		(
			StaffID,
			3
		),
		' - ',
		LastName
	) Staff,
	Email,
	Gender
FROM
	MsStaff
WHERE
	Salary > 1.6 * POWER(10, 6);

--3
CREATE VIEW
	vw_Q3OrderList
AS
	SELECT
		[to].OrderID,
		CONCAT
		(
			mc.FirstName,
			' ',
			mc.LastName
		) [Customer Name],
		CONVERT
		(
			CHAR,
			[to].OrderDate,
			105
		) [Order Date],
		tod.RentalDuration
	FROM
		TrOrderDetail tod
	INNER JOIN
		TrOrder [to]
	ON
		tod.OrderID = [to].OrderID
	INNER JOIN
		MsCustomer mc
	ON
		[to].CustomerID = mc.CustomerID
	WHERE
		DATEPART
		(
			YEAR,
			[to].OrderDate
		) = 2021
	AND
		DATEPART
		(
			MONTH,
			[to].OrderDate
		)
	BETWEEN
		7
	AND
		9;

DROP VIEW
	vw_Q3OrderList;

--4
SELECT
	REPLACE
	(
		mf.Title,
		SUBSTRING
		(
			mf.Title,
			CHARINDEX
			(
				' ',
				mf.Title
			) + 1,
			LEN(mf.Title)
		),
		mg.GenreName
	) Title,
	CONCAT
	(
		CONVERT
		(
			VARCHAR,
			YEAR(mf.ReleaseDate)
		),
		' : ',
		mf.Director
	) [Film Details]
FROM
	MsFilms mf
INNER JOIN
	MsGenre mg
ON
	mf.GenreID = mg.GenreID
INNER JOIN
	MsRegion mr
ON
	mf.RegionID = mr.RegionID
WHERE
	Title
LIKE
	'% %'
AND
	mr.RegionName
LIKE
	'%Europe%';

SELECT
	REPLACE('Andra Andre', 'Andre', 'Budi'),
	SUBSTRING('Abed', 2, 5), -- Abe
	CHARINDEX(' ', 'A b ed'); -- 2

--5
SELECT
	CASE
		WHEN
			mc.Gender = 'M'
		THEN
			'Mr. '
		ELSE
			'Ms. '
	END
		+ mc.FirstName 
		+ ' ' 
		+ mc.LastName [Customer Name],
	CONVERT
	(
		CHAR,
		[to].OrderDate,
		105
	) [Order Date],
	mf.Title
FROM
	TrOrderDetail tod
INNER JOIN
	MsFilms mf
ON
	tod.FilmID = mf.FilmID
INNER JOIN
	TrOrder [to]
ON
	tod.OrderID = [to].OrderID
INNER JOIN
	MsCustomer mc
ON
	[to].CustomerID = mc.CustomerID
INNER JOIN
	MsPayment mp
ON
	[to].PaymentMethodID = mp.PaymentMethodID
WHERE
	mp.PaymentMethodName = 'E-Wallet';

--6
SELECT
	CASE
		WHEN
			Gender = 'F'
		THEN
			'Female'
		ELSE
			'Male'
	END
		+ ' Staff' Gender,
	'Rp. ' +
	CAST
	(
		SUM(Salary)
		AS
			VARCHAR
	) +
	',-' [Total Salary]
FROM
	MsStaff
GROUP BY
	Gender;

--7
SELECT
	LEFT
	(
		mr.RegionName,
		2
	) +
	' ' +
	mf.Title Title,
	REVERSE
	(
		SUBSTRING
		(
			REVERSE(mf.Director),
			1,
			CHARINDEX
			(
				' ',
				REVERSE(mf.Director)
			) - 1
		)
	) +
	' ' +
	mf.Synopsis Synopsis,
	mf.ReleaseDate
FROM
	MsFilms mf
INNER JOIN
	MsGenre mg
ON
	mf.GenreID = mg.GenreID
INNER JOIN
	MsRegion mr
ON
	mf.RegionID = mr.RegionID
WHERE
	mg.GenreName = 'Horror';

-- Jae Hyuk

--8
SELECT
	LOWER(mc.FirstName) +
	' ' +
	LOWER(mc.LastName) [Customer Name],
	COUNT
	(
		DISTINCT
			[to].OrderID
	) [Order Count],
	COUNT(mf.FilmID) [Film Count]
FROM
	TrOrderDetail tod
INNER JOIN
	MsFilms mf
ON
	tod.FilmID = mf.FilmID
INNER JOIN
	TrOrder [to]
ON
	tod.OrderID = [to].OrderID
INNER JOIN
	MsCustomer mc
ON
	[to].CustomerID = mc.CustomerID
WHERE
	YEAR([to].OrderDate) = 2021
AND
	MONTH([to].OrderDate)
BETWEEN
	2
AND
	12
GROUP BY
	LOWER(mc.FirstName) +
	' ' +
	LOWER(mc.LastName)
ORDER BY
	[Film Count],
	[Order Count] DESC;

--9
SELECT
	mc.FirstName + ' ' + mc.LastName [Customer Name],
	CONVERT
	(
		VARCHAR,
		CAST
		(
			[to].OrderDate
			AS
				TIME
		),
		100
	) [Customer Order Time],
	SUM(tod.RentalDuration) [Total Rental Duration]
FROM
	TrOrderDetail tod
INNER JOIN
	TrOrder [to]
ON
	tod.OrderID = [to].OrderID
INNER JOIN
	MsStaff ms
ON
	[to].StaffID = ms.StaffID
INNER JOIN
	MsCustomer mc
ON
	[to].CustomerID = mc.CustomerID
WHERE
	ms.LastName
IN
(
	'Sitorus',
	'Haryanti'
)
GROUP BY
	mc.FirstName + ' ' + mc.LastName,
	CONVERT
	(
		VARCHAR,
		CAST
		(
			[to].OrderDate
			AS
				TIME
		),
		100
	);

--10
SELECT
	mc.FirstName + ' ' + mc.LastName [Customer Name],
	CASE
		WHEN
			mc.Gender = 'M'
		THEN
			'Male'
		ELSE
			'Female'
	END
		[Customer Gender],
	COUNT
	(
		DISTINCT
			[to].OrderID
	) [Total Order Count],
	AVG(tod.RentalDuration) [Average Rental Duration]
FROM
	TrOrderDetail tod
INNER JOIN
	MsFilms mf
ON
	tod.FilmID = mf.FilmID
INNER JOIN
	MsRegion mr
ON
	mf.RegionID = mr.RegionID
INNER JOIN
	TrOrder [to]
ON
	tod.OrderID = [to].OrderID
INNER JOIN
	MsStaff ms
ON
	[to].StaffID = ms.StaffID
INNER JOIN
	MsCustomer mc
ON
	[to].CustomerID = mc.CustomerID
WHERE
	ms.LastName = 'Nuraini'
AND
	mr.RegionName
IN
(
	'Asia',
	'Africa',
	'America'
)
GROUP BY
	mc.FirstName + ' ' + mc.LastName,
	mc.Gender;

--11
CREATE PROCEDURE
	GetTopFiveFilms
AS
	SELECT TOP 5
		mf.Title,
		mf.Synopsis,
		tod.RentalDuration
	FROM
		TrOrderDetail tod
	INNER JOIN
		MsFilms mf
	ON
		tod.FilmID = mf.FilmID
	ORDER BY
		tod.RentalDuration DESC,
		mf.Title;
GO;

DROP PROCEDURE
	GetTopFiveFilms;
GO;

--12
CREATE PROCEDURE
	GetYearTotalFilm
AS
	SELECT
		YEAR([to].OrderDate) [FilmYear],
		COUNT
		(
			DISTINCT
				mf.FilmID
		) [CountData]
	FROM
		TrOrderDetail tod
	INNER JOIN
		TrOrder [to]
	ON
		tod.OrderID = [to].OrderID
	INNER JOIN
		MsFilms mf
	ON
		tod.FilmID = mf.FilmID
	GROUP BY
		YEAR([to].OrderDate);
GO;

DROP PROCEDURE
	GetYearTotalFilm;
GO;

--13
CREATE PROCEDURE
	GetOrderByCustomer @CustomerID CHAR(5)
AS
	SELECT
		[to].OrderID,
		[to].OrderDate,
		mc.FirstName + ' ' + mc.LastName [CustomerName],
		mf.Title,
		tod.RentalDuration
	FROM
		TrOrderDetail tod
	INNER JOIN
		MsFilms mf
	ON
		tod.FilmID = mf.FilmID
	INNER JOIN
		TrOrder [to]
	ON
		tod.OrderID = [to].OrderID
	INNER JOIN
		MsCustomer mc
	ON
		[to].CustomerID = mc.CustomerID
	WHERE
		mc.CustomerID = @CustomerID;
GO;

EXEC
	GetOrderByCustomer @CustomerID = 'MC001';
GO;

DROP PROCEDURE
	GetOrderByCustomer;
GO;

--14
CREATE PROCEDURE
	GetFilm @RegionName VARCHAR(50), @GenreName VARCHAR(50) = NULL
AS
	BEGIN
		IF @GenreName IS NULL
			BEGIN
				SELECT
					mf.Title,
					mg.GenreName,
					mf.ReleaseDate,
					mf.Synopsis,
					mf.Director
				FROM
					MsFilms mf
				INNER JOIN
					MsGenre mg
				ON
					mf.GenreID = mg.GenreID
				INNER JOIN
					MsRegion mr
				ON
					mf.RegionID = mr.RegionID
				WHERE
					mr.RegionName = @RegionName
				ORDER BY
					mf.ReleaseDate DESC
			END
		ELSE
			BEGIN
				SELECT
					mf.Title,
					mg.GenreName,
					mf.ReleaseDate,
					mf.Synopsis,
					mf.Director
				FROM
					MsFilms mf
				INNER JOIN
					MsGenre mg
				ON
					mf.GenreID = mg.GenreID
				INNER JOIN
					MsRegion mr
				ON
					mf.RegionID = mr.RegionID
				WHERE
					mr.RegionName = @RegionName
				AND
					mg.GenreName = @GenreName
				ORDER BY
					mf.ReleaseDate DESC
			END
	END;
GO;

EXEC
	GetFilm @RegionName = 'Asia', @GenreName = 'Horror';
GO;

EXEC
	GetFilm @RegionName = 'Asia', @GenreName = NULL;
GO;

DROP PROCEDURE
	GetFilm;
GO;

--15
CREATE PROCEDURE
	GetOrderByCode @OrderID VARCHAR(6) = NULL, @OrderDetailID VARCHAR(6) = NULL
AS
	BEGIN
		IF (@OrderID IS NULL AND @OrderDetailID IS NOT NULL)
			BEGIN
				SELECT
					[to].OrderID,
					[to].OrderDate,
					mf.Title,
					CONCAT
					(
						YEAR(mf.ReleaseDate), 
						' : ',
						mf.Director
					) [Release Detail],
					tod.RentalDuration
				FROM
					TrOrderDetail tod
				INNER JOIN
					TrOrder [to]
				ON
					tod.OrderID = [to].OrderID
				INNER JOIN
					MsFilms mf
				ON
					tod.FilmID = mf.FilmID
				WHERE
					tod.OrderDetailID = @OrderDetailID
			END
		ELSE IF (@OrderID IS NOT NULL AND @OrderDetailID IS NULL)
			BEGIN
				SELECT
					[to].OrderID,
					[to].OrderDate,
					mf.Title,
					CONCAT
					(
						YEAR(mf.ReleaseDate), 
						' : ',
						mf.Director
					) [Release Detail],
					tod.RentalDuration
				FROM
					TrOrderDetail tod
				INNER JOIN
					TrOrder [to]
				ON
					tod.OrderID = [to].OrderID
				INNER JOIN
					MsFilms mf
				ON
					tod.FilmID = mf.FilmID
				WHERE
					[to].OrderID = @OrderID
			END
		ELSE IF (@OrderID IS NOT NULL AND @OrderDetailID IS NOT NULL)
			BEGIN
				SELECT
					[to].OrderID,
					[to].OrderDate,
					mf.Title,
					CONCAT
					(
						YEAR(mf.ReleaseDate), 
						' : ',
						mf.Director
					) [Release Detail],
					tod.RentalDuration
				FROM
					TrOrderDetail tod
				INNER JOIN
					TrOrder [to]
				ON
					tod.OrderID = [to].OrderID
				INNER JOIN
					MsFilms mf
				ON
					tod.FilmID = mf.FilmID
				WHERE
					[to].OrderID = @OrderID
				AND
					tod.OrderDetailID = @OrderDetailID
			END
	END;
GO;

EXEC
	GetOrderByCode @OrderID = 'TO002', @OrderDetailID = NULL;
GO;

EXEC
	GetOrderByCode @OrderID = NULL, @OrderDetailID = 'OD004';
GO;

DROP PROCEDURE
	GetOrderByCode;
GO;