mkdir bmuxmkv;
echo "Creating bmuxmkv/ to store the output of mkvmerge"
echo ""

count=1
for f in *.mkv;
  do name=`echo "$f"`
    outputfile=`echo "${name%.mkv}_1.mkv"`
    echo "${count}"
    echo "Multiplexing file : ${outputfile}"
    inputfile="${name}"
    finalname=`echo "${name%.mkv}.mkv"`
    subtitlefile="${name%.mkv}.srt"

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
    echo "Moving Muxed File to bmuxmkv/"
    mv "${outputfile}" bmuxmkv/
    echo "Going inside bmuxmkv/"
    cd bmuxmkv/
    echo "Renaming the file"
    mv "${outputfile}" "${finalname}"
    mkvpropedit "${finalname}" --set title="" --delete-track-statistics-tags --tags all:
    echo "Renamed the file!"
    echo "Coming out of bmuxmkv/"
    cd ..
    echo "-------------------------------------------------------------"
    echo ""
    count=`expr $count + 1`
done
