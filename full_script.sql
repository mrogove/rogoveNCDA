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

drop table if exists play_priority;
CREATE TABLE `play_priority`
(
	  `TEAM_ID`       smallint(5)
	, `TEAM_NAME`   TINYTEXT COLLATE latin1_general_ci
    , `PICK_PRIORITY` smallint(5)

) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
commit;

DELIMITER //
DROP PROCEDURE IF EXISTS nameMatches;//
create PROCEDURE nameMatches()
BEGIN
 update match_history as mh1,
 (
 select distinct t1.name, t1.join_id
 from teams t1
 left outer join match_history mh2
	on mh2.team_1_id = t1.join_id
 ) as mh2
 set mh1.team_1_name = mh2.name
 where mh1.team_1_id = mh2.join_id;
 
  update match_history as mh1,
 (
 select distinct t1.name, t1.join_id
 from teams t1
 left outer join match_history mh2
	on mh2.team_1_id = t1.join_id
 ) as mh2
 set mh1.team_2_name = mh2.name
 where mh1.team_2_id = mh2.join_id;

 END //

 DELIMITER ;
 
 
DELIMITER //

DROP procedure IF EXISTS returnMatches;//
CREATE PROCEDURE returnMatches (team_list varchar(125))
BEGIN
truncate match_history;
truncate match_history;
-- if no team_list, run for all. If team_list, FIND_IN_SET

	IF team_list IS NULL THEN 
	
	insert into match_history (team_1_id, team_2_id)

	select distinct t1.join_id, t2.join_id 
		from teams t1
		join teams t2
		where t2.join_id <> t1.join_id
	order by 1, 2 asc
	;

	ELSE
	insert into match_history (team_1_id, team_2_id)

	select distinct t1.join_id, t2.join_id 
		from teams t1
		join teams t2
		where t2.join_id <> t1.join_id
		  and find_in_set(t1.join_id, team_list) <> 0 
		  and find_in_set(t2.join_id, team_list) <> 0 
	order by 1, 2 asc
	;

	END IF;

call nameMatches();

END //
DELIMITER ;

/*
	UPDATE match_history with all scores from timeframe.

	takes date variable (format: '2014-07-10') to determine
		which history to look at. If NULL, then all time.
*/
DELIMITER //
drop procedure if exists scoreMatches;//
CREATE PROCEDURE scoreMatches(startDate date)
BEGIN 
set sql_Safe_updates = 0;

	if startDate IS NULL then
	update match_history as h inner join
	(
		select mh1.team_1_name, mh1.team_2_name, count(*)  AS score 
		from results r
		, match_history mh1
			where w_id in (mh1.team_1_id, mh1.team_2_id)
			and   l_id in (mh1.team_1_id, mh1.team_2_id)
		group by mh1.team_1_name, mh1.team_2_name
	) as a1

	set h.PLAYED = a1.score
	where a1.team_1_name = h.team_1_name
	  and a1.team_2_name = h.team_2_name;

	ELSE
	update match_history as h inner join
	(
		select mh1.team_1_name, mh1.team_2_name, count(*)  AS score 
		from results r
		, match_history mh1
			where w_id in (mh1.team_1_id, mh1.team_2_id)
			and   l_id in (mh1.team_1_id, mh1.team_2_id)
			and	  r.date >= startDate
		group by mh1.team_1_name, mh1.team_2_name
	) as a1

	set h.PLAYED = a1.score
	where a1.team_1_name = h.team_1_name
	  and a1.team_2_name = h.team_2_name
	;

	END IF;

END //
DELIMITER ;

/*
	select statement to return teams that need 
		to play games against new teams.
*/

DELIMITER //

DROP PROCEDURE IF EXISTS rankSuggestions;//
CREATE PROCEDURE rankSuggestions()
BEGIN
insert into play_priority (team_id, team_name, PICK_PRIORITY)
select  mh.team_1_id    as TEAM_ID
	  , MH.TEAM_1_NAME  as TEAM_NAME
	  , SUM(MH.PLAYED)  as PICK_PRIORITY 
      from match_history MH
GROUP BY MH.TEAM_1_NAME
ORDER BY 3 desc;

END //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS returnSuggestions;//
CREATE PROCEDURE returnSuggestions(team_list TINYINT(6))
BEGIN

	IF team_list IS NULL then 

	SELECT DISTINCT mh.TEAM_1_NAME, mh.TEAM_2_NAME, MH.PLAYED
			FROM match_history mh
            inner join play_priority pp
				on pp.team_id = mh.team_1_id
		order by pp.pick_priority desc
        , mh.team_1_name
        , mh.PLAYED ASC
        , MH.TEAM_2_NAME ASC
		;

	ELSE
	SELECT DISTINCT mh.TEAM_1_NAME, mh.TEAM_2_NAME, MH.PLAYED
			FROM match_history mh
            inner join play_priority pp
				on pp.team_id = mh.team_1_id
				where 
		   		 find_in_set(t1.join_id, team_list) <> 0 
		order by pp.pick_priority desc
        , mh.team_1_name
        , mh.PLAYED ASC
        , MH.TEAM_2_NAME ASC
		;

	END IF;

END //
DELIMITER ;

call returnMatches('1,2,3,4,6,8,10,12,13,14,15,25,26,27,29,31');

call scoreMatches('2014-07-01');

call rankSuggestions();
call returnSuggestions(NULL);
 
 