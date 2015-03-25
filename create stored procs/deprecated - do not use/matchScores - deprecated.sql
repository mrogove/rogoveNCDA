/*
	UPDATE match_history with all scores.
	-- incorporate function call to take in a date.
*/

DELIMITER //
CREATE PROCEDURE scoreMatches()
BEGIN 
set sql_Safe_updates = 0;

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
END //
DELIMITER ;