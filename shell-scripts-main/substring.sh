#! /bin/bash

# take a word from user and put in var $word
read -r -p "Please input your word: " word

# check how much letters does it contain
size=${#word}

# print the number
echo "Your word contain $size letters"

read  -r -p "Do you want to proceed?" ask
case $ask in
y|Y)
  echo "You said yes"
  ;;
n|N)
  echo "You said no"
  ;;
*)
  echo "Please use N/n or Y/y"
esac
