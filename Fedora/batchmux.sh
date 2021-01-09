helpFunction()
{
   echo ""
   echo "Usage: $0 -c 'mp4 / mkv' -s 'srt / vtt'"
   echo -e "\t-c The container of the input file"
   echo -e "\t-s Subtitle Type"
   exit 1 # Exit script after printing help
}

while getopts "c:s:" opt
do
   case "$opt" in
      c ) container="$OPTARG" ;;
      s ) subtitletype="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$container" ] || [ -z "$subtitletype" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

mkdir bmux"${container}";
echo "Creating bmux${container}/ to store the output of mkvmerge"
echo ""

count=1
for f in *."${container}";
  do name=`echo "$f"`
    outputfile=`echo "${name%.${container}}_1.mkv"`
    echo "${count}"
    echo "Multiplexing file : ${outputfile}"
    inputfile="${name}"
    finalname=`echo "${name%.${container}}.mkv"`
    subtitlefile="${name%.${container}}.${subtitletype}"

    echo "Input File    : ${inputfile}"
    echo "Subtitle File : ${subtitlefile}"
    echo "Output File   : ${outputfile}"
    mkvmerge --ui-language en_US \
 --output "${outputfile}" \
 --language 0:en \
 --language 1:en \
 --no-subtitles \
 '(' "${inputfile}" ')'\
 --sub-charset 0:UTF-8\
 --language 0:en\
 '(' "${subtitlefile}" ')'\
 --track-order 0:0,0:1,1:0;

    echo ""
    echo "Moving Muxed File to bmux${container}/"
    mv "${outputfile}" bmux"${container}"/
    echo "Going inside bmux${container}/"
    cd bmux"${container}"/
    echo "Renaming the file"
    mv "${outputfile}" "${finalname}"
    mkvpropedit "${finalname}" --set title="" --delete-track-statistics-tags --tags all:
    echo "Renamed the file!"
    echo "Coming out of bmux${container}/"
    cd ..
    echo "-------------------------------------------------------------"
    echo ""
    count=`expr $count + 1`
done
