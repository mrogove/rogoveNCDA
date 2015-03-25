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