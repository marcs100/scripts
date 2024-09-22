#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC=$'\e[0m'

if [ -z $1 ]; then
  echo -e "${RED}No package name given${NC}"
  exit
fi  

#seach the local nix store
i=0
while read line
do
    pkg_dirs[ $i ]=${line}        
    (( i++ ))
done < <(find /nix/store -name "*-${1}-*" -type d)

#process the search result
if [ $i -eq 0 ]; then  # no entries found 
  echo -e "${RED}package not found${NC}"
  exit
elif [ $i -eq 1 ]; then #only one entry found so go ahead and list it
  echo -e "${GREEN}Listing files for $pkg_dirs[0]${NC}"
  ls -R ${pkg_dirs[0]}
else #more than one found so give user some options
  echo
  echo -e "${GREEN}Found $i entries${NC}"
  echo
  
  #display entries
  entry_index=1
  pkg_index=0
  for pkg_dir in "${pkg_dirs[@]}"
  do
    echo -e "${BLUE}(${entry_index}) ${pkg_dirs[$pkg_index]}${NC}"
    ((entry_index++))
    ((pkg_index++))
  done
  echo
  
  read -p "('a')=all, (<n>)=choose number, ('q'=quit)" user_in 
  echo
  case $user_in in 
    "q")
      exit
      ;;
    "a")
      #iterate through matching package dirs
      for pkg_dir in "${pkg_dirs[@]}"
      do
        echo
        echo -e "${GREEN}Listing files for $pkg_dir${NC}"
        echo
        ls -R $pkg_dir
        echo
      done
      ;;  
    *)
      #test we have a number and it is not greater than num of pkgs found 
      if [[ $user_in =~ ^[0-9]+$ ]]; then
         #we have a number is it in range
         if [ $user_in -gt $i ]; then
           echo -e "${RED} number out of range${NC}"
        else
          pkg_index=user_in-1
          echo -e "${GREEN} Listing files for ${pkg_dirs[$pkg_index]}${NC}" 
          ls -R ${pkg_dirs[$pkg_index]}  
        fi  
      else
         echo -e "${RED}invalid option!${NC}"
         exit
      fi
  esac
fi

