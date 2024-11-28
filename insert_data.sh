#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games,teams")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do  
  if [[ $YEAR != year ]]
  then  
      #VERIFICA SI EL EQUIPO GANADOR(WINNER) YA SE ENCUENTRA EN LA TABLA
      TEAM_EXISTS=$($PSQL "select name from teams where name='$WINNER'")
      #si el equipo ganador no existe lo ingresamos
      if [[ -z $TEAM_EXISTS ]]
      then
        INSERT_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
        if [[ $INSERT_TEAM == "INSERT 0 1" ]]
        then
          echo "Inserted team: $WINNER"
        fi
      fi
      #VERIFICA SI EL EQUIPO OPONENTE(OPPONENT) YA SE ENCUENTRA EN LA TABLA
      TEAM_EXITS=$($PSQL "select name from teams where name='$OPPONENT'")
      #si el equipo opponente no existe lo insertamos
      if [[ -z $TEAM_EXITS ]]
      then
        INSERT_TEAM=$($PSQL "insert into teams(name) values('$OPPONENT')")
        if [[ $INSERT_TEAM == "INSERT 0 1" ]]
        then
          echo "Inserted team: $OPPONENT"
        fi  
      fi
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
      INSERT_GAMES=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
      if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo "Inserted into GAMES, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS"
      fi
  fi
done