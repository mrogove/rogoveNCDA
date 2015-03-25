DELIMITER //
CREATE PROCEDURE scoreReturn 
(root_id SMALLINT, second_id SMALLINT)
BEGIN
	select count(*) AS score 
	from results 
		where w_id in (root_id, second_id)
		and   l_id in (root_id, second_id);
END //
DELIMITER ;

