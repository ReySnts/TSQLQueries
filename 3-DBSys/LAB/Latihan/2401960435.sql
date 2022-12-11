--2401960435 - Reynaldy Sentosa.
USE The_Externational
--1
SELECT
	DISTINCT
	player_name = a.playerName,
	[Team Region] = b.regionName,
	[Player Region] = a.regionName
FROM
	(
		SELECT
			playerName = player_name,
			regionName = region_name
		FROM
			player p JOIN
			region r ON
			p.region_id = r.region_id
	) a,
	(
		SELECT
			regionName = region_name
		FROM
			team t JOIN
			region r ON
			t.region_id = r.region_id
	) b
WHERE
	a.regionName LIKE '% %'
--2
SELECT
	match_schedule,
	team_name,
	team_score
FROM
	match_detail md JOIN
	[match] m ON
	md.match_id = m.match_id JOIN
	team t ON
	md.team_id = t.team_id
WHERE
	DATEDIFF(DAY, match_schedule, '2021-10-20') = 8 AND
	team_score = 2
--3
SELECT
	team_name,
	total_play = alsubq.matchCount,
	total_score = alsubq.totalScore
FROM
	team t, (
		SELECT
			id = team_id,
			matchCount = COUNT(match_id),
			totalScore = SUM(team_score)
		FROM
			match_detail
		GROUP BY
			team_id
		HAVING
			COUNT(match_id) = 2 AND
			SUM(team_score) BETWEEN 0 AND 3
	) alsubq
WHERE
	t.team_id = alsubq.id
--4
SELECT
	player_name,
	position_name
FROM
	team_detail td JOIN
	position p ON
	td.position_id = p.position_id JOIN
	player pl ON
	td.player_id = pl.player_id
WHERE
	position_name IN('Support 4', 'Support 5', 'Carry') AND
	td.team_id IN(
		SELECT
			t.team_id
		FROM
			match_detail md JOIN
			team t ON
			md.team_id = t.team_id
		GROUP BY
			t.team_id
		HAVING
			SUM(team_score) IN(4, 5)
	)
--5
SELECT
	TOP(1)
	region_name = a.regionName,
	[Total Team] = a.totalTeam
FROM
	(
		SELECT
			regionName = region_name,
			totalTeam = COUNT(team_id)
		FROM
			team t JOIN
			region r ON
			t.region_id = r.region_id
		GROUP BY
			region_name
	) a,
	(
		SELECT
			maxTeam = MAX(a.totalTeam)
		FROM
			(
				SELECT
					regionName = region_name,
					totalTeam = COUNT(team_id)
				FROM
					team t JOIN
					region r ON
					t.region_id = r.region_id
				GROUP BY
					region_name
			) a
	) b
WHERE
	a.totalTeam = b.maxTeam
UNION
SELECT
	TOP(1)
	region_name = a.regionName,
	[Total Team] = a.totalTeam
FROM
	(
		SELECT
			regionName = region_name,
			totalTeam = COUNT(team_id)
		FROM
			team t JOIN
			region r ON
			t.region_id = r.region_id
		GROUP BY
			region_name
	) a,
	(
		SELECT
			minTeam = MIN(a.totalTeam)
		FROM
			(
				SELECT
					regionName = region_name,
					totalTeam = COUNT(team_id)
				FROM
					team t JOIN
					region r ON
					t.region_id = r.region_id
				GROUP BY
					region_name
			) a
	) b
WHERE
	a.totalTeam = b.minTeam
--6
SELECT
	team_name = a.spiritName,
	team_score = a.spiritScore,
	[Opponent] = b.oppName,
	[Opponent Score] = b.oppScore,
	CASE
		WHEN a.spiritScore = 2 THEN 'WIN'
		ELSE 'LOSE'
	END
		AS Result
FROM
	(
		SELECT
			id = match_id,
			spiritName = team_name,
			spiritScore = team_score
		FROM
			match_detail md JOIN
			team t ON
			md.team_id = t.team_id
		WHERE
			team_name = 'Team Spirit'
	) a,
	(
		SELECT
			id = match_id,
			oppName = team_name,
			oppScore = team_score
		FROM
			match_detail md JOIN
			team t ON
			md.team_id = t.team_id
		WHERE
			team_name NOT LIKE 'Team Spirit' AND
			match_id IN(
				SELECT
					match_id
				FROM
					match_detail md JOIN
					team t ON
					md.team_id = t.team_id
				WHERE
					team_name = 'Team Spirit'
			)
	) b
WHERE
	a.id = b.id
--7
GO
CREATE VIEW
	[Player Who Played the Most]
AS
	SELECT
		player_name
	FROM
		player p
	WHERE
		EXISTS(
			SELECT
				*
			FROM
				(
					SELECT
						id = player_id,
						playCount = COUNT(match_id)
					FROM
						match_detail md JOIN
						team t ON
						md.team_id = t.team_id JOIN
						team_detail td ON
						t.team_id = td.team_id
					GROUP BY
						player_id
				) a,
				(
					SELECT
						maxPlay = MAX(a.playCount)
					FROM
						(
							SELECT
								id = player_id,
								playCount = COUNT(match_id)
							FROM
								match_detail md JOIN
								team t ON
								md.team_id = t.team_id JOIN
								team_detail td ON
								t.team_id = td.team_id
							GROUP BY
								player_id
						) a
				) b
			WHERE
				a.playCount = b.maxPlay AND
				p.player_id = a.id
		)
--8
SELECT
	player_name,
	joined_date,
	team_name
FROM
	team t JOIN
	team_detail td ON
	t.team_id = td.team_id JOIN
	player p ON
	td.player_id = p.player_id
WHERE
	DATEDIFF(YEAR, joined_date, '2021-11-01') > 3
--9
SELECT
	player_name,
	position_name,
	team_name,
	joined_date
FROM
	team t JOIN
	team_detail td ON
	t.team_id = td.team_id JOIN
	player p ON
	td.player_id = p.player_id JOIN
	position po ON
	td.position_id = po.position_id
WHERE
	YEAR(joined_date) = 2021 AND
	MONTH(joined_date) < 10
--10
SELECT
	TOP(1)
	region_name,
	[Total Player] = COUNT(player_id)
FROM
	player p JOIN
	region r ON
	p.region_id = r.region_id
WHERE
	EXISTS(
		SELECT
			region_name,
			[Total Player] = COUNT(player_id)
		FROM
			player p JOIN
			region r ON
			p.region_id = r.region_id
		GROUP BY
			region_name
	)
GROUP BY
	region_name