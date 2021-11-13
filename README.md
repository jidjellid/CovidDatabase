# DB-PROJECT-COVID

Le rapport est disponible à la racine.

Le dossier data contient les fichiers sources.   
Le dossier docs contient des graphes préchargés.  
Le dossier graph contient les fichiers python utilisés pour générer ces graphes.  
Le dossier src contient les fichiers sql utilisés pour installer la base de donnée.  
Le dossier test contient des tests pour les fonctions de la base de donnée.  

# Installation
```sh
# Install the requirements
python3 -m pip install -r requirements.txt
```

Before installing the project, you should change the database's name in the ```Makefile``` and ```.database```. Then do:
```sh
make install 
```
By default, the database name is 'projet'.  
Make install will run all the commands below in order to process the files, create the tables, the triggers and insert the data


# Avaible commands for the Makefile
```sh
make install         # connects to the database and install everything
make pro             # processes the sources files into their -pro filtered counter parts 
make create_all      # creates tables and indexes
make create_trigger  # Creates triggers 
make insert_data     # inserts the data from the -pro csv files to the database 
make queries         # creates functions
make open            # starts the psql terminal
make gr ARGS=''      # takes a path as argument and execute the python file at said path
make check ARGS=''   # takes a path as argument and execute the SQL file at said path
make clean           # removes the processed files from the data folder
``` 
     
# Examples of commands

Execute the test 'TestCumulative.sql'
```sh
make check ARGS='./test/functions/TestCumulative.sql'
```
Replace the argument by any path of the folder test

---

Generate the graph 'GroupVaccinated.py'
```sh
make gr ARGS='./graph/GroupVaccinated.py'
```
Replace the argument by any path of the graph test, don't forget to input a country when asked



