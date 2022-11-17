#! /bin/bash

MAIN_MENU() {

  echo -e "\n~~  Alex's Salon ~~\n"
  echo -e "Let's get you scheduled girlfriend!"
  echo -e "\nWhat service do you need?\n1) Slap n Tickle\n2) Mowhawk\n3) Fade"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SLAP ;;
    2) MOWHAWK ;;
    3) FADE ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac


}
SLAP () {
  SERVICE="Slap n Tickel"
  GET_DEETS
}

MOWHAWK () {
  SERVICE="Mowhawk"
  GET_DEETS
}

FADE () {
  SERVICE="Fade"
  GET_DEETS
}

GET_DEETS () {
  
  echo -e "\nAwesome! What's your phone number"
  read CUSTOMER_PHONE

  # get customer id
  CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if no record of customer
   if [[ -z $CUSTOMER_ID ]]
   then
  # get name
  echo -e "\nSeems like we don't have record of you. Can I get your name please?"
  read CUSTOMER_NAME
  # insert into customer
  INSERT_CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  #echo -e "\nNew customer added. Welcome $CUSTOMER_NAME $CUSTOMER_PHONE"
  CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  GET_TIME
  else
  
   
  CUSTOMER_NAME_UNFORMATED=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
  CUSTOMER_NAME=$(echo $CUSTOMER_NAME_UNFORMATED | sed 's/ |/"/' )
  #echo "Customer found! $CUSTOMER_NAME"
  GET_TIME
  fi
}

GET_TIME () {
  # get time
  echo -e  "\nWhat time would you like?"
  read SERVICE_TIME
  # insert to appointments
  INSERT_INTO_APPOINTMENTS=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  # output message
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU