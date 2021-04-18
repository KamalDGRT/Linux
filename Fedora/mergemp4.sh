#######################################
# Merge mp4 files into one output mp4 file
# usage:
#   mergemp4 #merges all mp4 in current directory
#   mergemp4 video1.mp4 video2.mp4
#   mergemp4 video1.mp4 video2.mp4 [ video3.mp4 ...] output.mp4 
#######################################

# This Script is from StackOverFlow: https://stackoverflow.com/a/61151377


if [ $# = 1 ]; then return; fi

outputfile="output.mp4"

#if no arguments we take all mp4 in current directory as array
if [ $# = 0 ]; then inputfiles=($(ls -1v *.mp4)); fi
if [ $# = 2 ]; then inputfiles=($1 $2); fi  
if [ $# -ge 3 ]; then
  outputfile=${@: -1} # Get the last argument
  inputfiles=(${@:1:$# - 1}) # Get all arguments besides last one as array
fi
  
# -y: automatically overwrite output file if exists
# -loglevel quiet: disable ffmpeg logs
ffmpeg -y \
-loglevel quiet \
-f concat \
-safe 0 \
-i <(for f in $inputfiles; do echo "file '$PWD/$f'"; done) \
-c copy $outputfile

if test -f "$outputfile"; then echo "$outputfile created"; fi
echo "hi"
