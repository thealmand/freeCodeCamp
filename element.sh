#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

NUMBER_ENTERED () {
  #atomic number check
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ARGUMENT")
  if [[ -z $SYMBOL ]]
  then
   echo -e "I could not find that element in the database."
  else
    GET_INFO
  fi
}

OTHER_ENTERED () {
  # check if atomic symbol
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$ARGUMENT'")
  if [[ ! -z $SYMBOL ]]
  then
   GET_INFO
  else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$ARGUMENT'")
    if [[ -z $SYMBOL ]]
    then
      echo -e "I could not find that element in the database."
    else
      GET_INFO
    fi
  fi
}

GET_INFO () {

  SYMBOL2=$(echo $SYMBOL | sed 's/ //')

  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL2'")
  NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL2'")
  TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number = $NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER")

  NUMBER2=$(echo $NUMBER | sed 's/^ *//g')
  NAME2=$(echo $NAME | sed 's/^ *//g')
  TYPE2=$(echo $TYPE | sed 's/^ *//g')
  MASS2=$(echo $MASS | sed 's/^ *//g')
  MELTING_POINT2=$(echo $MELTING_POINT | sed 's/^ *//g')
  BOILING_POINT2=$(echo $BOILING_POINT | sed 's/^ *//g')

  echo "The element with atomic number $NUMBER2 is $NAME2 ($SYMBOL2). It's a $TYPE2, with a mass of $MASS2 amu. $NAME2 has a melting point of $MELTING_POINT2 celsius and a boiling point of $BOILING_POINT2 celsius."
  
}


ARGUMENT=$1

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
 NUMBER_ENTERED
else
  OTHER_ENTERED
fi



