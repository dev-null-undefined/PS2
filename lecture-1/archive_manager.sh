#!/usr/bin/env bash

# Pokud neexistuje, vytvořte adresář archive.
# V adresáři archive vytvořte adresář s názvem kódu semestru a časovou značkou (např. B102@2011-02-15_10:00:00) a na něj vedoucí link se jménem kódu semestru.
# Do tohoto adresáře zkopírujte obsah adresářů předmětů z courses.
# V adresáři každého předmětu změňte v souboru index řádek s nadpisem (=====) a doplňte do něj text: záloha z YYYY-MM-DD.
# V adresáři archive vytvořte adresáře předmětů a v nich linky na jednotlivé archivy předmětů v čase.

FOLDER="archive"
ROOT="courses"

current_date=$(date -u +"%Y-%m-%d_%H:%M:%S")

if [[ -e "$FOLDERx" ]]
then
   echo "FAILED file exists '$FOLDER'"
   exit 1
else
    current_year=$(cat "$ROOT/info")
    current_folder="${FOLDER}/${current_year}@${current_date}"
    mkdir -p "$current_folder"
    for folder in "$ROOT"/*
    do
        subject=$(cut -d"/" -f2,2 <<< "$folder")
        mkdir -p "${current_folder}/${subject}"
    done
    ln -sfn "${current_year}@${current_date}" "${FOLDER}/${current_year}"
fi
