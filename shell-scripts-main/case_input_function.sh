#! /bin/bash

# declare function ask
ask_func() {
case $ask in
y|Y)
  echo "That is good "
  ;;
n|N)
  printf "You said no\nThat is very sad :(\n"
  ;;
*)
  echo "Please use N/n or Y/y"
esac
}
# --------------------------------------------------
# declare function input_from
# function for ask
input_from() {
read  -r -p "Do you want to proceed? " ask
}
# --------------------------------------------------
# take a word from user and put in var $word
read -r -p "Please input your word: " word

# check how much letters does it contain
size=${#word}

# print the number
echo "Your word contain $size letters"

# use function input_from
input_from

ask_func
sleep 1
#input_from
echo "Your word in reverse"
sleep 1
echo  $word | rev # do reverse for word

# ask again
input_from
ask_func
sleep 1

echo "Your word in uppercase"
echo ${word^^} # change it to uppercase

input_from
ask_func

echo "Sorry this the end"