mkdir bmuxmp4;
echo "Creating bmuxmp4/ to store the output of mkvmerge"
echo ""

count=1
for f in *.mp4;
  do name=`echo "$f"`
    outputfile=`echo "${name%.mp4}_1.mkv"`
    echo "${count}"
    echo "Multiplexing file : ${outputfile}"
    inputfile="${name}"
    finalname=`echo "${name%.mp4}.mkv"`
    subtitlefile="${name%.mp4}.vtt"

    echo "Input File    : ${inputfile}"
    echo "Subtitle File : ${subtitlefile}"
    echo "Output File   : ${outputfile}"
    mkvmerge --ui-language en_US \
 --output "${outputfile}" \
 --language 0:en \
 --language 1:en \
 '(' "${inputfile}" ')'\
 --sub-charset 0:UTF-8\
 --language 0:en\
 '(' "${subtitlefile}" ')'\
 --track-order 0:0,0:1,1:0;

    echo ""
    echo "Moving Muxed File to bmuxmp4/"
    mv "${outputfile}" bmuxmp4/
    echo "Going inside bmuxmp4/"
    cd bmuxmp4/
    echo "Renaming the file"
    mv "${outputfile}" "${finalname}"
    mkvpropedit "${finalname}" --set title="" --delete-track-statistics-tags --tags all:
    echo "Renamed the file!"
    echo "Coming out of bmuxmp4/"
    cd ..
    echo "-------------------------------------------------------------"
    echo ""
    count=`expr $count + 1`
done
