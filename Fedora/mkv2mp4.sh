for i in *.mkv; do
    ffmpeg -i "$i" -codec copy "${i%.*}.mp4" -v quiet -stats
done
