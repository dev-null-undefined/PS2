#!/usr/bin/env bash

# V aktuálním adresáři jsou podadresáře, z nichž některé obsahují soubor start.txt. Vypište cestu k takovým souborům v pořadí podle jejich poslední modifikace. Např.:
# ./novak/start.txt
# ./jahoda/start.txt
# ./zavada/start.txt
# ./malina/start.txt

# Rozšiřte předchozí skript tak, aby bylo možné při dalším volání skriptu zobrazit pouze novější soubory než nejmladší soubor z předchozího běhu.

delimiter=","
stats=$(mktemp)

folder="."
last_edit_file="/tmp/.last_edited_epoch"

last_edit="0"
if [[ -e "$last_edit_file" ]]
then
    last_edit=$(cat "$last_edit_file")
fi

if [[ $# -ge 1 ]]
then
    folder="$1"
fi

for file in "$folder"/*/*.txt
do
    last_edit_current=$(stat -c "%Y" "$file")
    if [[ "$last_edit_current" -gt "$last_edit" ]]
    then
        printf "%s$delimiter%s\n" "$last_edit_current" "$file" >> "$stats"
    fi
done

temp_file=$(mktemp)
sort -k1rd -t "$delimiter" < "$stats" > "$temp_file"
mv "$temp_file" "$stats"
cut -d"$delimiter" -f2,2 < "$stats"

latest_edit=$(head -n 1 < "$stats" | cut -d"$delimiter" -f1,1)

if [[ -n "$latest_edit" ]]
then
    echo "$latest_edit" > "$last_edit_file"
fi

rm "$stats"
