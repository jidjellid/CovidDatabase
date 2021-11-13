\! echo 'Checking block_update trigger'
SELECT * FROM vaccination_europe WHERE date = '2021-05-09' AND country_name = 'France' AND manufacturer_name = 'AZ' and group_name = 'ALL';
\! echo 'Trying to update (2021-05-09,France,AZ,ALL) SET fully_vaccinated = 20'
UPDATE vaccination_europe SET fully_vaccinated = 20 WHERE date = '2021-05-09' AND country_name = 'France' AND manufacturer_name = 'AZ' and group_name = 'ALL';
SELECT * FROM vaccination_europe WHERE date = '2021-04-04' AND country_name = 'France' AND manufacturer_name = 'AZ' and group_name = 'ALL';
\! echo 'Trying to update (2021-04-04,France,AZ,ALL) SET fully_vaccinated = 20'
UPDATE vaccination_europe SET fully_vaccinated = 20 WHERE date = '2021-04-04' AND country_name = 'France' AND manufacturer_name = 'AZ' and group_name = 'ALL';
\! echo 'Previous update should have failed'



