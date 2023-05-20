#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Check for $1 if exist
if [[ -z $1 ]]
then
  #If not then end program with message
  echo -e "Please provide an element as an argument."
  #if it does, then check for it in database
else
  #check if input is number or string
  if [[ $1 =~ ^[0-9]*$ ]]
  then
    #if number, search by atomic_number
    ELEMENT_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    #if string, then search by name or symbol
    ELEMENT_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  #if database doesn't contain input, end progran
  if [[ -z $ELEMENT_EXIST ]]
  then
    echo -e "I could not find that element in the database."
  else
    #if it does make the response format
    $PSQL "SELECT * FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ELEMENT_EXIST" | while IFS="|" read TID AN AM MPC BPC SB NM T
    do
      #Display message and end program
      #echo $TID $AN $AM $MPC $BPC $SB $NM $T
      echo -e "The element with atomic number $AN is $NM ($SB). It's a $T, with a mass of $AM amu. $NM has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done 
  fi
fi
