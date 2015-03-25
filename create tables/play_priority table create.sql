drop table if exists play_priority;
CREATE TABLE `play_priority`
(
	  `TEAM_ID`       smallint(5)
	, `TEAM_NAME`   TINYTEXT COLLATE latin1_general_ci
    , `PICK_PRIORITY` smallint(5)

) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
commit;