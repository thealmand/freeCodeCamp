#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#clear info
echo $($PSQL "TRUNCATE teams, games")

# Add info from games.cvs to teams table

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#ignore first line
if [[ $YEAR != "year" ]]
then
   # Add info from games.cvs to teams table
     #Get team names winners
       WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        #if not found
         if [[ -z $WINNER_TEAM_ID ]]
         then
          #insert team name
          WINNER_INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          if [[ $WINNER_INSERT_NAME == "INSERT 0 1" ]]
          then
           echo Winner name inserted into teams, $WINNER
         fi
        fi
        #get new team name
          WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #Get Team names opponent
        OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        # tester echo $OPPONENT
        #if not found
          if [[ -z $OPPONENT_TEAM_ID ]]
          then
            #insert team name
            OPPONENT_INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            if [[ $OPPONENT_INSERT_NAME == "INSERT 0 1" ]]
            then
              echo Opponent name inserted into teams, $OPPONENT
            fi
          fi
          #get new team name
            OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
            

    #insert game
    INSERT_LIKEBOSS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo Like a boss $YEAR $ROUND $WINNER
    
fi
done
