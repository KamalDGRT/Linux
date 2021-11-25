#!/bin/bash

mkdir rar_files
for i in *.rar; do
    name=$(echo "$i")
    echo "Extracting ..."
    echo "${name}"
    echo ""
    unrar x "${name}"
    echo ""
    echo "${name} is extracted!"
    echo ""
    echo "------------------------------------------"
    echo ""
done

mv *.rar rar_files
