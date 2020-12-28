mkdir nosubsmkv;
echo "Creating nosubsmkv/ to store the output of mkvmerge"
echo ""

count=1
for file in *.mkv;
  do name=`echo "$file"`
    outputfile=`echo "${name%.mkv}_1.mkv"`
    echo "${count}"
    echo "Multiplexing file : ${outputfile}"
    inputfile="${name}"
    finalname=`echo "${name%.mkv}.mkv"`

    echo "Input File    : ${inputfile}"
    echo "Output File   : ${outputfile}"

	mkvmerge -o "${outputfile}" --no-subtitles "$inputfile"

    echo ""
    echo "Moving Muxed File to nosubsmkv/"
    mv "${outputfile}" nosubsmkv/
    echo "Going inside nosubsmkv/"
    cd nosubsmkv/
    echo "Renaming the file"
    mv "${outputfile}" "${finalname}"
    mkvpropedit "${finalname}" --set title="" --delete-track-statistics-tags --tags all:
    echo "Renamed the file!"
    echo "Coming out of nosubsmkv/"
    cd ..
    echo "-------------------------------------------------------------"
    echo ""
    count=`expr $count + 1`
done
