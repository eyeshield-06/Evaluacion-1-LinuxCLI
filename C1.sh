########## 1.1)
# descarga de datos desde Dropbox
wget "https://www.dropbox.com/scl/fi/d4ror2587jug3h4n6howo/mcdonalds_menu.zip?e=7&file_subpath=%2Fmcdonalds_menu.csv&rlkey=s9qe77iqsvko12xae163aqrab&st=u1g2d7ms&dl=0" -O files.zip

########## 1.2)
# guradamos los archivos aqui, para hacer mas sencillo el item 1.2)
mkdir dir

unzip "files.zip" -d ./dir

ls ./dir > files.txt

########## 1.3)
head ./dir/mcdonalds_menu.csv --lines=100 > mcdonalds_menu_100.csv

########## 2.1)
cat ./dir/mcdonalds_menu.csv | csvcut -c Category | sed -e "1d" | sort | uniq > categories.txt

########## 2.2)
cat ./dir/mcdonalds_menu.csv | csvcut -c "Serving Size" | sed -e "1d" | sort | uniq > servin_sizes.txt

########## 2.3)
grep "Breakfast" -C 1 ./dir/mcdonalds_menu.csv > breakfast.csv

########## 2.4)
# el archivo aux.csv es para filtrar los items del menu que son medidos en gramos,
# ya que algunos estan en ml como los batidos, oz, o otros que incluso no se brinda
# la informacion
csvcut -c 'Serving Size' ./dir/mcdonalds_menu.csv | grep -oP "\(\K[^\)]+" -n | grep "g" | cut -d ' ' -f -1 > aux.csv

# se crea la nueva variable solo con los elementos que es posible, y en los que no
# se deja con valor nulo
./aux.R

########## 2.5)
csvsql --query "SELECT Item, Calper100g FROM mcdonalds_menu_2 ORDER BY Calper100g DESC LIMIT 0, 3" ./mcdonalds_menu_2.csv > top.csv

csvsql --query "SELECT Item, Calper100g FROM mcdonalds_menu_2 WHERE Calper100g > 0 ORDER BY Calper100g LIMIT 0, 3" ./mcdonalds_menu_2.csv >> top.csv

########## 2.6)
# se crea colnames.R, ya que al usar rush con la opcion --dry-run, vemos que internamente
# manipula el nombre de las variables con janitor, por lo que es dificil predecir el nombre
# dado a las variables solo viendo el csv, por lo que con este script auxiliar obtenemos los
# nombres de las variables a plotear y los guardamos en un archivo de texto que posteriormente
# recorremos con un ciclo for, realizando asi todos los histogramas de las variables de
# interes.
./colnames.R > vars_to_plot.txt

mkdir histograms

n=$(wc -l vars_to_plot.txt | cut -d' ' -f 1)

for (( i=1 ; i<=$n ; i++ )); 
do
   aux=`sed "$i!d" vars_to_plot.txt`
   echo $aux
   rush plot --x "$aux" ./dir/mcdonalds_menu.csv > ./histograms/$aux.png
done
