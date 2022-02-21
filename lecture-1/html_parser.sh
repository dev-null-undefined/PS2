#!/usr/bin/env bash

# Z URL: https://gitlab.fit.cvut.cz/barinkl/bi-ps2-public/raw/master/edux/index.html vyberte kódy předmětů začínajících na B,M nebo P.
# Vytvořte adresář courses a v něm adresáře podle kódů předmětů.
# Do každého adresáře předmětu vytvořte soubor index a do něj text ===== kód_předmětu ===== (případně můžete ze stránky předmětu zjisti jméno předmětu - viz např.: https://gitlab.fit.cvut.cz/barinkl/bi-ps2-public/raw/master/edux/BI-PS2/start.txt ).
# V adresáři courses vytvořte soubor info do kterého uložíte kód semestru (např. B102, kde 10 je podle ak.roku a 2 znamená letní semestr).


URL="https://gitlab.fit.cvut.cz/barinkl/bi-ps2-public/raw/master/edux/index.html"

FILE=$(mktemp)
ROOT="courses"
wget "$URL" -O "$FILE" &> /dev/null

lecture_prefixes="BMP"
allowed_chars="A-Z.0-9"

for subject in $(sed -r -e "s/.*([$lecture_prefixes][$allowed_chars]*-[$allowed_chars]*).*/\\1/p;d" < "$FILE");
do
    folder="$ROOT/$subject"
    mkdir -p "$folder"
    echo -n "===== $subject =====" > "$folder/index"
done

record_date=$(sed -r -e 's#.*([0-9]{4,6}-[0-9]{2}-[0-9]{2}).*#\1#p;d' < "$FILE" | head -n 1)

year=$(cut -d "-" -f1,1 <<< "$record_date")
month=$(cut -d "-" -f2,2 <<< "$record_date")
year="${year: 2:2}"

year_code="B$year"

if [[ "$month" -ge 3 ]] && [[ "$month" -le 10 ]]
then
    year_code="${year_code}2"
else
    year_code="${year_code}1"
fi

echo "$year_code" > "$ROOT/info"

rm "$FILE"
