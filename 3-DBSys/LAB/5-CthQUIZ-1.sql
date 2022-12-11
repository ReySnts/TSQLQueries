USE doto

--1
BEGIN TRAN
CREATE TABLE Items(
	ItemId CHAR(5) PRIMARY KEY
	CHECK(ItemId LIKE 'IT[0-9][0-9][0-9]'),
	ItemName VARCHAR(255) NOT NULL,
	ItemDescription VARCHAR(255) NOT NULL
	CHECK(LEN(ItemDescription) > 5),
	ItemPrice NUMERIC(10, 2) NOT NULL
)
COMMIT ROLLBACK

SELECT * FROM Items

--2
BEGIN TRAN
ALTER TABLE Heroes
ADD HeroInitHP INT
COMMIT ROLLBACK

BEGIN TRAN
ALTER TABLE Heroes
ADD CONSTRAINT HeroInitHP_Const
CHECK(HeroInitHP BETWEEN 30 AND 100)
COMMIT ROLLBACK

--3
BEGIN TRAN
INSERT INTO Users
VALUES('US006', 'fy', 'fygod.123', 'fy@gmail.com')
COMMIT ROLLBACK

--4
SELECT REPLACE(EquipmentId, 'EQ', 'Equipment ') AS EquipmentId, 
eq.EquipmentName, eq.EquipmentRarity, eq.EquipmentPrice
FROM Equipments eq JOIN Heroes h
ON eq.HeroId = h.HeroId
WHERE h.HeroAttribute IN('Agility', 'Strength')

--5
BEGIN TRAN
UPDATE Equipments
SET EquipmentRarity = 'Arcana'
FROM Equipments eq JOIN Heroes h
ON eq.HeroId = h.HeroId 
WHERE h.HeroAttribute LIKE 'S%'
COMMIT ROLLBACK

SELECT * FROM Equipments