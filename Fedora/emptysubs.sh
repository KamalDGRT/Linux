#!/bin/bash

helpFunction() 
{
  echo ""
  echo "Usage: $0 -c 'mp4 / mkv / avi'"
  echo -e "\t-c The container of the input file."
  exit 1 # Exit script after printing help
}

while getopts "c:" opt
do
  case "$opt" in
    c ) container="$OPTARG" ;;
    ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

# Print helpFunction in case the parameter is not given
if [ -z "$container" ]
then
  echo "The video container is not specified!!";
  helpFunction
fi

count=`ls -1 *.${container} 2>/dev/null | wc -l`

if [ $count != 0 ] 
  then

  # Creating a directory (if it isn't present) to store the subtitles
  if [[ ! -d subs/ ]]
    then
      mkdir subs
      echo "Created subs/ folder to store subtitles!"
  fi

  # Traversing through the files with the specified container
  for file in *.${container};
    do 
      name=`echo "$file"`
      echo "Creating Subtitle for :  ${name}"

      # Creating the SubRip (.srt) subtitle file
      subname="${name%.${container}}.srt"
      content="1\n00:00:00,000 --> 00:00:10,000\nNo Subtitles Available!!!\n\n"
      printf "$content" >> "${subname}"

      # Moving the newly created file to subs/ directory
      mv "${subname}" subs/
      echo "${subname} has been created in subs/ folder."
      echo ""
      echo "-------------------------------------------------------------"
      echo ""
  done
else
  # Cleanup in case there are no files present!
  echo "There are no ${container} files in the current directory!"
  rmdir subs/
  echo "Removed subs/ folder!"
fi 
