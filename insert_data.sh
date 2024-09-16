#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then 
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')") 
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi

    TEAM_ID2=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $TEAM_ID2 ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')") 
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi

    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ $TEAM_ID_WINNER && $TEAM_ID_OPPONENT ]]
    then
      INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into games, $YEAR, $ROUND, $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS
      fi
    fi

  fi
done