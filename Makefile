DATABASE = projet

install:
	make pro create_all create_trigger insert_data queries

create_all:
	psql -d $(DATABASE) -f ./src/create_all.sql

create_trigger:
	psql -d $(DATABASE) -f ./src/create_trigger.sql

queries:
	psql -d $(DATABASE) -f ./src/queries.sql

insert_data:
	psql -d $(DATABASE) -f ./src/insert_data.sql

pro:
	python3 ./data/processing.py

gr:
	python3 $(ARGS)

open:
	psql -d $(DATABASE)

check:
	psql -d $(DATABASE) -f $(ARGS)

clean:
	rm ./data/*pro.csv