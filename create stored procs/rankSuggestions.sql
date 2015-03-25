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