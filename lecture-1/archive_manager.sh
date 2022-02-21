#!/usr/bin/env bash

# Pokud neexistuje, vytvořte adresář archive.
# V adresáři archive vytvořte adresář s názvem kódu semestru a časovou značkou (např. B102@2011-02-15_10:00:00) a na něj vedoucí link se jménem kódu semestru.
# Do tohoto adresáře zkopírujte obsah adresářů předmětů z courses.
# V adresáři každého předmětu změňte v souboru index řádek s nadpisem (=====) a doplňte do něj text: záloha z YYYY-MM-DD.
# V adresáři archive vytvořte adresáře předmětů a v nich linky na jednotlivé archivy předmětů v čase.

FOLDER="archive"
ROOT="courses"

current_date=$(date -u +"%Y-%m-%d_%H:%M:%S")

if [[ -e "$FOLDER" ]]
then
   echo "FAILED file exists '$FOLDER'"
   exit 1
else
    for folder in "$ROOT"/*
    do
        subject=$(cut -d"/" -f2,2 <<< "$folder")
        current_folder="${subject}@${current_date}"
        mkdir -p "${FOLDER}/$current_folder"
        ln -s "$current_folder" "${FOLDER}/${subject}"
    done
fi
