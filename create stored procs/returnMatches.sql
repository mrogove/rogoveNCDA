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