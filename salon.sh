#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_PROMPT () {

echo -e "\n How may I help you today?\n1) Cut\n2) Color\n3) Perm"
GET_SERVICE
}


GET_SERVICE () {
read SERVICE_ID_SELECTED
CHECK_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $CHECK_SERVICE_ID ]]
then
echo -e "\nPlease select a valid service."
MAIN_PROMPT
else
  GET_NAME
fi
}

GET_NAME () {

echo -e "\nMay I get your phone number please?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
echo -e "\nMay I get your name please?"
read CUSTOMER_NAME
INSERT_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
GET_TIME
else
GET_TIME
fi
}

GET_TIME () {

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nAnd what time would you like to schedule?"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME." | sed 's/  / /' | sed 's/  / /'

}



echo -e "\n~~~~ Welcome to Alex's Salon ~~~~\n"
MAIN_PROMPT


