#! /bin/bash
 
PSQL="psql --username=freecodecamp --dbname=salon  --tuples-only -c"
 
# show service list function

SERVICES_LIST_RESULT=$($PSQL "
SELECT * 
FROM services

")
 
CHOSEN_SERVICE_RESULT=""
   
SERVICE_ID_SELECTED=""
 
while [[ -z $CHOSEN_SERVICE_RESULT ]]
do
 
  echo "$SERVICES_LIST_RESULT" | while read SERVICE_ID BAR NAME
  do
 
    echo "$SERVICE_ID) $NAME"
 
  done

  echo -e "\nChoose service you would like to purchase (service number):"
  read SERVICE_ID_SELECTED
 
  CHOSEN_SERVICE_RESULT=$($PSQL "
  SELECT *
  FROM services
  WHERE service_id = $SERVICE_ID_SELECTED

  ")

  

done
 
echo "$SERVICE_ID_SELECTED"


echo -e "\nProvide your customer details:"

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

# chekc if customer phone exists in customers table

CHECK_CUSTOMER_PHONE_RESULT=$($PSQL "
SELECT * 
FROM customers
WHERE phone = '$CUSTOMER_PHONE'
")

if [[ -z $CHECK_CUSTOMER_PHONE_RESULT ]]
  then

    echo -e "\nWhat's your name?"

    read CUSTOMER_NAME

    ADD_NEW_CUSTOMER_RESULT=$($PSQL "
    INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

fi


echo -e "\nPlease provide time you would like to have your service" 

read SERVICE_TIME


CUSTOMER_ID=$($PSQL "
SELECT customer_id 
FROM customers
WHERE phone = '$CUSTOMER_PHONE'
")
ADD_NEW_APPOINTMENT_RESULT=$($PSQL "
INSERT INTO appointments(customer_id, service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')
")

SERVICE_SELECTED_NAME=$($PSQL "
SELECT name
FROM services
WHERE service_id  = $SERVICE_ID_SELECTED
")

echo -e "\nI have put you down for a $SERVICE_SELECTED_NAME at $SERVICE_TIME, $CUSTOMER_NAME."




