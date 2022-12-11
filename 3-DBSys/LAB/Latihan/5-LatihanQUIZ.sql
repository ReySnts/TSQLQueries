USE The_Externational

-- No. 1
CREATE TABLE leaderboard(
	rank_id CHAR(5) PRIMARY KEY NOT NULL
	CHECK(rank_id LIKE 'RNK[0-9][0-9]'),
	team_id CHAR(5) FOREIGN KEY
	REFERENCES team(team_id),
	[rank] INT NOT NULL
	CHECK([rank] BETWEEN 1 AND 8),
	prize BIGINT NOT NULL
)
-- No. 2
BEGIN TRAN
ALTER TABLE team_detail
ADD is_captain INT
COMMIT ROLLBACK

BEGIN TRAN
ALTER TABLE team_detail
ADD CONSTRAINT checkCaptain
CHECK(is_captain BETWEEN 0 AND 1)
COMMIT ROLLBACK

--No. 3
INSERT INTO position
VALUES('POS06', 'Coach')

-- No. 4
SELECT player_name, joined_date
FROM player pl JOIN team_detail td
ON pl.player_id = td.player_id
WHERE joined_date LIKE '2019-09%'
--FROM player pl, team_detail td
--WHERE pl.player_id = td.player_id
--AND DATENAME(YEAR, joined_date) = 2019
--AND DATENAME(MONTH, joined_date) = 'September'
--AND joined_date LIKE '2019-09%'

--No. 5
BEGIN TRAN
UPDATE match_detail
SET team_score = 2
WHERE match_id LIKE 'MT010'
AND team_id LIKE 'TM006'
COMMIT ROLLBACK