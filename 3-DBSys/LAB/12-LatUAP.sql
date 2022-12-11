DROP DATABASE The_Externational
USE The_Externational
--1

--2
SELECT
	match_schedule,
	team_name,
	team_score
FROM
	[match] m JOIN
	match_detail md ON
	m.match_id = md.match_id JOIN
	team t ON
	md.team_id = t.team_id
WHERE
	DATEDIFF(DAY, match_schedule, '2021-10-20') = 8 AND
	team_score = 2
--3
SELECT
	team_name = teamSubq.teamName,
	total_play = matchDetSubq.totalPlay,
	total_score = matchDetSubq.totalScore
FROM
	(
		SELECT
			teamID = team_id,
			teamName = team_name
		FROM
			team
	) teamSubq,
	(
		SELECT
			teamID = team_id,
			totalScore = SUM(team_score),
			totalPlay = COUNT(match_id)
		FROM
			match_detail
		GROUP BY
			team_id
	) matchDetSubq
WHERE
	matchDetSubq.totalPlay = 2 AND
	matchDetSubq.totalScore BETWEEN 0 AND 3 AND
	teamSubq.teamID = matchDetSubq.teamID
--4
SELECT
	player_name,
	position_name
FROM
	team_detail td JOIN
	player pl ON
	td.player_id = pl.player_id JOIN
	position po ON
	td.position_id = po.position_id
WHERE
	position_name IN('Support 4', 'Support 5', 'Carry') AND
	team_id IN(
		(
			SELECT
				t.team_id
			FROM
				match_detail md JOIN
				team t ON
				md.team_id = t.team_id
			GROUP BY
				t.team_id
			HAVING
				SUM(team_score)
				IN(4, 5)
		)
	)
--5
SELECT
	TOP(1)
	region_name = a.regionName,
	[Total Team] = a.[Total Team]
FROM
	(
		SELECT
			regionName = region_name,
			[Total Team] = COUNT(team_id)
		FROM
			team t JOIN
			region r ON
			t.region_id = r.region_id
		GROUP BY
			region_name
	) a,
	(
		SELECT
			maxTeam = MAX(a.[Total Team])
		FROM
			(
				SELECT
					regionName = region_name,
					[Total Team] = COUNT(team_id)
				FROM
					team t JOIN
					region r ON
					t.region_id = r.region_id
				GROUP BY
					region_name
			) a
	) b
WHERE
	a.[Total Team] = b.maxTeam
UNION
SELECT
	TOP(1)
	region_name = a.regionName,
	[Total Team] = a.[Total Team]
FROM
	(
		SELECT
			regionName = region_name,
			[Total Team] = COUNT(team_id)
		FROM
			team t JOIN
			region r ON
			t.region_id = r.region_id
		GROUP BY
			region_name
	) a,
	(
		SELECT
			minTeam = MIN(a.[Total Team])
		FROM
			(
				SELECT
					regionName = region_name,
					[Total Team] = COUNT(team_id)
				FROM
					team t JOIN
					region r ON
					t.region_id = r.region_id
				GROUP BY
					region_name
			) a
	) b
WHERE
	a.[Total Team] = b.minTeam
----6
--SELECT
--	*
--FROM
--	match_detail md JOIN
--	team t ON
--	md.team_id = t.team_id

--SELECT
--	team_name,
--	team_score
--	--,[Opponent] = 
--FROM
--	match_detail md JOIN
--	team t ON
--	md.team_id = t.team_id, (
--		SELECT
--			team_name
--		FROM
--			team
--		WHERE
--			team_id IN(
--				SELECT
--					team_id
--				FROM
--					match_detail
--				WHERE
--			)
--	)
--WHERE
--	team_name = 'Team Spirit'
--7
CREATE VIEW
	[Player Who Played the Most]
AS
	SELECT
		player_name = a.playerName
	FROM
		(
			SELECT
				playerName = player_name,
				playerMatchCount = COUNT(match_id)
			FROM
				match_detail md JOIN
				team t ON
				md.team_id = t.team_id JOIN
				team_detail td ON
				t.team_id = td.team_id JOIN
				player p ON
				td.player_id = p.player_id
			GROUP BY
				player_name
		) a,
		(
			SELECT
				maxMatchCount = MAX(a.playerMatchCount)
			FROM
				(
					SELECT
						playerName = player_name,
						playerMatchCount = COUNT(match_id)
					FROM
						match_detail md JOIN
						team t ON
						md.team_id = t.team_id JOIN
						team_detail td ON
						t.team_id = td.team_id JOIN
						player p ON
						td.player_id = p.player_id
					GROUP BY
						player_name
				) a
		) b
	WHERE
		a.playerMatchCount = b.maxMatchCount
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
	team_detail td JOIN
	team t ON
	td.team_id = t.team_id JOIN
	position po ON
	td.position_id = po.position_id JOIN
	player pl ON
	td.player_id = pl.player_id
WHERE
	YEAR(joined_date) = 2021 AND
	MONTH(joined_date) < 10
--10
SELECT
	TOP(1)
	region_name = a.regionName,
	[Total Player] = a.playerCount
FROM
	(
		SELECT
			regionName = region_name,
			playerCount = COUNT(player_id)
		FROM
			player p JOIN
			region r ON
			p.region_id = r.region_id
		GROUP BY
			region_name
	) a,
	(
		SELECT
			maxPlayer = MAX(a.playerCount)
		FROM
			(
				SELECT
					regionName = region_name,
					playerCount = COUNT(player_id)
				FROM
					player p JOIN
					region r ON
					p.region_id = r.region_id
				GROUP BY
					region_name
			) a
	) b
WHERE
	a.playerCount = b.maxPlayer