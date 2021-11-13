\echo '\n**INSERT TESTING**\n'

DELETE FROM testing WHERE country_name = 'testCountry';
DELETE FROM countries WHERE name = 'testCountry';
INSERT into countries VALUES('testCountry',10000,0.5,50,50,100000,0,0,0,0,0,0,0);

SELECT * FROM testing WHERE country_name = 'testCountry';
\echo '\nInserting first value\n'
SELECT insertTesting('2020-05-05','testCountry','0','0','0','0','0','0','0');
\echo '\nChecking first isnert\n'
SELECT * FROM testing WHERE country_name = 'testCountry';
\echo '\nInserting second value\n'
SELECT insertTesting('2020-05-05','testCountry','1','0','0','0','0','0','0');
\echo '\nChecking second insert\n'
SELECT * FROM testing WHERE country_name = 'testCountry';
SELECT insertTesting('2020-05-06','testCountry',2,'3','0',new_deaths:='5');
SELECT * FROM testing WHERE country_name = 'testCountry';

\echo '\n**INSERT VACCINATION_EUROPE**\n'

DELETE FROM vaccination_europe WHERE country_name = 'testCountry2';
DELETE FROM countries WHERE name = 'testCountry2';
INSERT into countries VALUES('testCountry2',10000,0.5,50,50,100000,0,0,0,0,0,0,0);

SELECT * FROM vaccination_europe WHERE country_name = 'testCountry2';
\echo '\nInserting first value\n'
SELECT insertVaccinationEurope('2020-05-05','testCountry2','AZ','ALL','1000','100','30');
\echo '\nChecking first insert\n'
SELECT * FROM vaccination_europe WHERE country_name = 'testCountry2';
\echo '\nInserting second value, this should get stopped by the trigger\n'
SELECT insertVaccinationEurope('2020-05-05','testCountry2','AZ','ALL','1500','200','60');
\echo '\nChecking second insert\n'
SELECT * FROM vaccination_europe WHERE country_name = 'testCountry2';
SELECT insertVaccinationEurope('2020-05-06','testCountry2','AZ','ALL','3000','200','60');
SELECT * FROM vaccination_europe WHERE country_name = 'testCountry2';



