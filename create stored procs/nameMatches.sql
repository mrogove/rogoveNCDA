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