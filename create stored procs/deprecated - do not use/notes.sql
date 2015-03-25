--scoreReturn--
--return the matchfreq score of the two teams

--Need to account for list in ID selection

////////////////////////////////////////////////////////////////////////
--Need to account for dates in query that pulls scores from results.
////////////////////////////////////////////////////////////////////////
--also want: sum team_1''s scores. They get top priority.
update to exclude teams with PickPriority of 0 (they have not played in period)

	write as separete toolkit query/stored procedure
////////////////////////////////////////////////////////////////////////
--replace monster code with function calls.
////////////////////////////////////////////////////////////////////////
--update return matches for:
-- WHERE() variable list of participating schools:
-- --
--	AND FIND_IN_SET(t1.join_id, @listvar)
--	AND FIND_IN_SET(t2.join_id, @listvar)
-- --
--USE: FIND_IN_SET: SET --

--@idcamposexcluidos='817,803,495';
--...
--WHERE FIND_IN_SET(id_campo, @idlistexamples) <> 0
////////////////////////////////////////////////////////////////////////
Write toolkit query for "Give me X number of matches for team Y"
////////////////////////////////////////////////////////////////////////
Package up the stored processes
////////////////////////////////////////////////////////////////////////
--update returnMatches for season history.

--update returnMatches to reflect the all-ID-combinations effort

--writing update table statement to enter all ID combinations 
--	where id <> column_id_1
-- DONE!

-- unique matches only!
-- DONE!