//////////////////////////////////
READ-ME
//////////////////////////////////
3/24/2015
Michael Rogove
mrogove@gmail.com


//////////////////////////////////
TO DO LOG:
3-31-2015 MR
	-- Update RESULTS table with new results.
		Format with Sublime.
	-- Remove the doublelist logic. 
		Reinstate part of deprecated returnMatches proc such that only 1 appearance of each match.
	-- Add additional column to play_priority
	-- Add proc to take diff of team rankings (as provided by ZM), insert into table.
	-- Draw only 3 unique matches. Use ROWNUM > X logic. Options:
		1) Janky: create new table. Insert into, delete from old.
		2) Better: create cursor.
		3) Worst: Do this manually. This may have to be done in the future anyway 
			(if a team cancels, other unforseen matchday events)

//////////////////////////////////
DESCRIPTION:
executing "full_script.sql" should create and execute 
	the necessary tables and scripts.

//////////////////////////////////
TABLES:
match_history -- Which teams have played each other? How many times?

play_priority -- What teams have played a lot of other teams?
				 This should have just been an inner select...
//////////////////////////////////
PROCEDURES:

[nameMatches() --called implicitly by returnMatches. Sorry. 
				 Joins Names to the IDs. Should have been a join. ]

returnMatches(teamlist varchar(125))
				this uses a FIND_IN_SET, so teamlist should be like:
													('1,2,3,4,etc')
				IF NULL: all teams will be present.

scoreMatches(startDate date)
				How far back should we score? My example is '2014-07-01'.
				IF NULL: All time.

rankSuggestions()
				Which teams have played other teams a lot of times?

returnSuggestions(team_list TINYINT(6))
				Well, put them first, and the 
				teams they haven't played yet first.

				IF NULL: all teams still in the list
				WITH TEAMLIST: just these teams ('1,2,3,4,etc').
				
//////////////////////////////////
CALL EXAMPLES:
IN ORDER:

call returnMatches('1,2,3,4,6,8,10,12,13,14,15,25,26,27,29,31');

call scoreMatches('2014-07-01');

call rankSuggestions();
call returnSuggestions(NULL);
 
 //////////////////////////////////
 other notes:

Sorry for making it all in mySQL.

The stored procedures should truncate and refresh the two tables I've 
made. As such, updates to TEAMS and RESULTS should pull through.

The nice thing about this roundabout approach is that when you finally
look at the results output by returnSuggestions(NULL); , it's a broad
table of just that - suggestions. Here are the hard facts about which
teams have played which. I assume a human will be involved in setting
the Saturday schedules anyway, so having a reference sheet is nice.
Maybe some teams can't play at certain times, or there might be other
logistical issues. In that case, having a full list of suggestions
helps. returnSuggestions(NULL); should return those teams with high
playing scores first. In our run through from 2014-07-01 to 2015-03-12,
C Michigan U, Grand Valley, and others played each other and other teams
a BUNCH. So they are listed first.

for the full story:
SELECT * FROM match_history;
