#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

MAIN() {
  ELEMENT=''
  GET_ELEMENT $1
  DOES_EXIST_IN_DB $ELEMENT
  PRINT_FORMATTED "$ELEMENT"
}

GET_ELEMENT() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    exit
  elif [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi
}

DOES_EXIST_IN_DB() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
    exit
  fi
}

PRINT_FORMATTED() {
  echo "$1" | { 
    read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  }
}

MAIN $1