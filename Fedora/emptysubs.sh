mkdir subs;
for f in *.mp4;
  do name=`echo "$f"`
    echo "Creating Subtitle for :  ${name}"
    subname="${name%.mp4}.srt"
    content="1\n00:00:00,000 --> 00:00:07,000\nNo Subtitles Available!!!\n\n"
    printf "$content" >> "${subname}"
    mv "${subname}" subs/
    echo "${subname} has been created in subs/ folder."
    echo ""
    echo "-------------------------------------------------------------"
    echo ""
done

