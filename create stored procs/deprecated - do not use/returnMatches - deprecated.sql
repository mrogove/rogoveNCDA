/*
	need to update for all possible IDs in a list
*/
drop procedure returnMatches;

DELIMITER //
create PROCEDURE returnMatches (team_list varchar(125))
BEGIN
truncate all_id_matches;

-- if no team_list, run for all. If team_list, FIND_IN_SET

	IF team_list IS NULL THEN 
	(
	insert into all_id_matches (team_1_id, team_2_id)

	select distinct t1.join_id, t2.join_id 
		from teams t1
		join teams t2
		where t2.join_id <> t1.join_id
	order by 1, 2 asc
	;
	truncate match_history;
	insert into match_history (team_1_id, team_2_id)
	SELECT DISTINCT team_1_id,team_2_id
	FROM all_id_matches t1 
	WHERE t1.team_1_id < t1.team_2_id
	    OR NOT EXISTS (
	        SELECT * FROM all_id_matches t2 
	            WHERE t2.team_1_id = t1.team_2_id AND t2.team_2_id = t1.team_1_id );
	);

	ELSE
	(insert into all_id_matches (team_1_id, team_2_id)

	select distinct t1.join_id, t2.join_id 
		from teams t1
		join teams t2
		where t2.join_id <> t1.join_id
		  and find_in_set(t1.join_id, team_list) <> 0 --LIMIT TO LIST
		  and find_in_set(t2.join_id, team_list) <> 0 --LIMIT TO LIST
	order by 1, 2 asc
	;
	truncate match_history;
	insert into match_history (team_1_id, team_2_id)
	SELECT DISTINCT team_1_id,team_2_id
	FROM all_id_matches t1 
	WHERE t1.team_1_id < t1.team_2_id
	    OR NOT EXISTS (
	        SELECT * FROM all_id_matches t2 
	            WHERE t2.team_1_id = t1.team_2_id AND t2.team_2_id = t1.team_1_id );
	);

	END IF;

call nameMatches();

/*names*/
END //
DELIMITER ;