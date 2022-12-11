--create database pertemuan2
--use pertemuan2
--create table MsCustomer(
--	CustomerID char(5) primary key
--	constraint checkID
--	check(CustomerID like 'CU[0-9][0-9][0-9]'),
--	CustomerName varchar(50) not null,
--	CustomerDOB date not null
--)
--alter table MsCustomer
--drop constraint checkID

--alter table MsCustomer
--add constraint checkID
--check(CustomerID like 'ID[0-9][0-9][0-9]')
-------------------------------------------------
--alter table MsCustomer
--add CustomerEmail varchar(20)

--alter table MsCustomer
--add constraint checkEmail 
--check(CustomerEmail like '%.com')

--alter table MsCustomer
--drop constraint checkEmail
--------------------------------------------------
--create table MsFisherman(
--	FishermanID char(5) primary key
--	check (FishermanID like 'FS[0-9][0-9][0-9]'),
--	FishermanName varchar(50) not null 
--)
--create table MsFishType(
--	FishTypeID char(5) primary key
--	check(FishTypeID like 'FT[0-9][0-9][0-9]'),
--	FishTypeName varchar(50) not null
--)
--create table MsFish(
--	FishID char(5) primary key
--	check(FishID like 'FI[0-9][0-9][0-9]'),
--	FishTypeID char(5) foreign key
--	references MsFishType(FishTypeID)
--	on update cascade
--	on delete cascade,
--	FishName varchar(50) not null,
--	FishPrice int not null
--)
--create table TransactionHeader(
--	TransactionID char(5) primary key
--	check(TransactionID like 'TR[0-9][0-9][0-9]'),
--	FishermanID char(5) foreign key
--	references MsFisherman(FishermanID)
--	on update cascade
--	on delete cascade,
--	CustomerID char(5) foreign key
--	references MsCustomer(CustomerID)
--	on update cascade
--	on delete cascade
--)
--create table TransactionDetail(
--	TransactionID char(5) foreign key
--	references TransactionHeader(TransactionID)
--	on update cascade
--	on delete cascade,
--	FishID char(5) foreign key
--	references MsFish(FishID)
--	on update cascade
--	on delete cascade,
--	primary key(TransactionID, FishID)
--)

--select * from TransactionDetail

--begin tran
--drop table TransactionDetail
--commit rollback

--begin tran
--drop table TransactionHeader
--commit rollback

-----------------------------------------------------
-----------------------------------------------------

--1
BEGIN TRAN
CREATE TABLE MsCustomer(
	CustomerID CHAR(5) PRIMARY KEY
	CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(50) NOT NULL,
	CustomerGender VARCHAR(10) NOT NULL,
	CustomerAddress VARCHAR(50) NOT NULL,
	CustomerEmail VARCHAR(50) NOT NULL,
	CustomerDOB DATE NOT NULL
)
CREATE TABLE MsFisherman(
	FishermanID CHAR(5) PRIMARY KEY
	CHECK(FishermanID LIKE 'FS[0-9][0-9][0-9]'),
	FishermanName VARCHAR(50) NOT NULL,
	FishermanGender VARCHAR(10) NOT NULL,
	FishermanAddress VARCHAR(50) NOT NULL
)
CREATE TABLE MsFishType(
	FishTypeID CHAR(5) PRIMARY KEY
	CHECK(FishTypeID LIKE 'FT[0-9][0-9][0-9]'),
	FishTypeName VARCHAR(50) NOT NULL
)
CREATE TABLE MsFish(
	FishID CHAR(5) PRIMARY KEY
	CHECK(FishID LIKE 'FI[0-9][0-9][0-9]'),
	FishTypeID CHAR(5)
	REFERENCES MsFishType(FishTypeID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FishName VARCHAR(50) NOT NULL,
	FishPrice INT NOT NULL
)
CREATE TABLE TransactionHeader(
	TransactionID CHAR(5) PRIMARY KEY
	CHECK(TransactionID LIKE 'TR[0-9][0-9][0-9]'),
	FishermanID CHAR(5)
	REFERENCES MsFisherman(FishermanID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CustomerID CHAR(5)
	REFERENCES MsCustomer(CustomerID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	TransactionDate DATE NOT NULL
)
CREATE TABLE TransactionDetail(
	TransactionID CHAR(5)
	REFERENCES TransactionHeader(TransactionID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FishID CHAR(5)
	REFERENCES MsFish(FishID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	Quantity INT NOT NULL,
	PRIMARY KEY(TransactionID, FishID)
)
COMMIT ROLLBACK

SELECT * FROM MsCustomer
SELECT * FROM MsFisherman
SELECT * FROM MsFishType
SELECT * FROM MsFish
SELECT * FROM TransactionHeader
SELECT * FROM TransactionDetail

--2
BEGIN TRAN
DROP TABLE TransactionDetail
COMMIT ROLLBACK

--3
BEGIN TRAN
CREATE TABLE TransactionDetail(
	TransactionID CHAR(5)
	REFERENCES TransactionHeader(TransactionID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FishID CHAR(5)
	REFERENCES MsFish(FishID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	Quantity INT NOT NULL
)
COMMIT ROLLBACK

BEGIN TRAN
ALTER TABLE TransactionDetail
ADD CONSTRAINT Const PRIMARY KEY(TransactionID, FishID)
COMMIT ROLLBACK

--4
