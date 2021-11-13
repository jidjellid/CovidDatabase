\! echo 'Checking transfer_travel trigger'
SELECT * FROM testing WHERE country_name = 'France' AND date = '2021-04-15';
SELECT * FROM testing WHERE country_name = 'Mexico' AND date = '2021-04-15';

\! echo 'Inserting 10 new fligths from Mexico to France in 2021-04-15'
INSERT into travel values('Mexico','France','2021-04-15',10);

SELECT * FROM testing WHERE country_name = 'France' AND date = '2021-04-15';
SELECT * FROM testing WHERE country_name = 'Mexico' AND date = '2021-04-15';

DELETE FROM travel WHERE departure_country = 'Mexico' and arrival_country = 'France' and date = '2021-04-15'






