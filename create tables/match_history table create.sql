drop table if exists match_history;
CREATE TABLE `match_history`
(
	  `TEAM_1_ID`   TINYINT(6) NOT NULL
	, `TEAM_2_ID`   TINYINT(6) NOT NULL
	, `TEAM_1_NAME` TINYTEXT COLLATE latin1_general_ci
	, `TEAM_2_NAME` TINYTEXT COLLATE latin1_general_ci
	, `PLAYED`		TINYINT(6) DEFAULT 0
	, PRIMARY KEY (`TEAM_1_ID`, `TEAM_2_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;