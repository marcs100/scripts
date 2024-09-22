#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "No package name given"
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
  echo package not found!
  exit
elif [ $i -eq 1 ]; then #only one entry found so go ahead and list it
  ls -R ${pkg_dirs[0]}
else #more than one found so give user some options
  echo
  echo Found $i entries
  echo
  
  #display entries
  entry_index=1
  pkg_index=0
  for pkg_dir in "${pkg_dirs[@]}"
  do
    echo "(${entry_index})" "${pkg_dirs[$pkg_index]}"
    ((entry_index++))
    ((pkg_index++))
  done

  read -p "('a')=all, (<n>)=choose number, ('q'=quit)" user_in 

  case $user_in in 
    "q")
      exit
      ;;
    "a")
      #iterate through matching package dirs
      for pkg_dir in "${pkg_dirs[@]}"
      do
        echo
        echo **** Listing files for $pkg_dir
        echo
        ls -R $pkg_dir
        echo
      done
      ;;  
    *)
      #test we have a number and it is not greater than num of pkgs found 
      if [[ $user_in =~ ^[1-1000]+$ ]]; then
         #we have a number is it in range
         if [ $user_in -gr $i ]; then
           echo number out of range
        else
          ls -R ${pkg_dirs[$user_in]}  
        fi  
      else
         echo invalid option!!!!
         exit
      fi
  esac
fi

