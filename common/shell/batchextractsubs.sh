mkdir subs

for f in *.mkv; do
    name=$(echo "$f")
    echo "Extracting subtitle from ${name}"
    subname="${name%.mkv}.srt"
    ffmpeg -i "$f" -c:s copy "${subname}" -v quiet -stats
    mv "${subname}" subs/
    echo "${subname} has been created in subs/ folder."
    echo ""
    echo "-------------------------------------------------------------"
    echo ""
done
