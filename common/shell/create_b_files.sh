# a="Question_"
qvar=Question_
start=1
end=10

for((i=$start;i<=$end;i++))
do
	qno=`printf "%02d" $i`
	file1='question'_$qno.c
	file2='README.md'
    foldername=$qvar$qno

    echo 'Creating Folder '$foldername
    mkdir $foldername
    echo 'Going Inside '$foldername
    cd $foldername
    echo "Creating "$file1
    touch $file1
    echo "Creating "$file2
    touch $file2
    echo "Exiting from "$foldername
    cd ..
    echo ""
done
