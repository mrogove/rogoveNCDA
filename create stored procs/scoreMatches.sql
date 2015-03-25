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
