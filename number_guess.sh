#!/bin/bash

#PSQL variable
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#get random number
SECRET_NUMBER=$(( $RANDOM %1000 ))
#echo $SECRET_NUMBER

#prompt for username
echo "Enter your username:"
read USERNAME

# check insert and output based off input
USERNAME_CHECK=$($PSQL "SELECT username FROM game_data WHERE username = '$USERNAME'")
if [[ -z $USERNAME_CHECK ]]
then
  #if new username
  #insert username and games played
  INSERT_USERNAME=$($PSQL "INSERT INTO game_data(username, games_played) VALUES('$USERNAME', 1)")
  #output welcome message
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  #if existing username
  #get games played and best game
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM game_data WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM game_data WHERE username = '$USERNAME'")
  #incriment games played
  #GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))
  INSERT_GAMES_PLAYED=$($PSQL "UPDATE game_data SET games_played = ( games_played + 1 ) WHERE username = '$USERNAME'")
  #output existing welcome message
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

#collect guess
echo "Guess the secret number between 1 and 1000:"
read GUESS
#start collecting tries
NUMBER_OF_GUESSES=1

#guess and hint loop
while [[ $GUESS -ne $SECRET_NUMBER ]]
do

#if guess is non intiger
if [[ ! $GUESS =~ ^[0-9]*$ ]]
then
    echo -e "That is not an integer, guess again:"
#if else guess is greater than number
elif [[ $GUESS -gt $SECRET_NUMBER ]]
then
  echo -e "It's lower than that, guess again:"
#else guess is less than number
elif [[ $GUESS -lt $SECRET_NUMBER ]]
then
  echo "It's higher than that, guess again:"
fi

read GUESS
#increment tries
NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1))

done

if [[ $GUESS = $SECRET_NUMBER ]]
then
echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice Job!"
fi

#if first time or new best
if [[ -z $USERNAME_CHECK ]] || [[ $NUMBER_OF_GUESSES -le $BEST_GAME ]]
then
#insert best game
  INSERT_BEST_GAME=$($PSQL "UPDATE game_data SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME'")
fi



