# descargar database
wget "https://www.dropbox.com/scl/fi/d4ror2587jug3h4n6howo/mcdonalds_menu.zip?e=7&file_subpath=%2Fmcdonalds_menu.csv&rlkey=s9qe77iqsvko12xae163aqrab&st=u1g2d7ms&dl=0" -O files.zip

mkdir dir

unzip "files.zip" -d ./dir

ls ./dir > files.txt

head ./dir/mcdonalds_menu.csv --lines=100 > mcdonalds_menu_100.csv

cat ./dir/mcdonalds_menu.csv | csvcut -c Category | sed -e "1d" | sort | uniq > categories.txt

cat ./dir/mcdonalds_menu.csv | csvcut -c "Serving Size" | sed -e "1d" | sort | uniq > servin_sizes.txt

grep "Breakfast" -C 1 ./dir/mcdonalds_menu.csv > breakfast.csv

csvcut -c 'Serving Size' ./dir/mcdonalds_menu.csv | grep -oP "\(\K[^\)]+" -n | grep "g" | cut -d ' ' -f -1 > aux.csv

./aux.R

csvsql --query "SELECT Item, Calper100g FROM mcdonalds_menu_2 ORDER BY Calper100g DESC LIMIT 0, 3" ./mcdonalds_menu_2.csv > top.csv

csvsql --query "SELECT Item, Calper100g FROM mcdonalds_menu_2 WHERE Calper100g > 0 ORDER BY Calper100g LIMIT 0, 3" ./mcdonalds_menu_2.csv >> top.csv

csvstat ./dir/mcdonalds_menu.csv --type | grep "Number" | cut -d: -f 1 | cut -c 6- > vars_to_plot.txt
