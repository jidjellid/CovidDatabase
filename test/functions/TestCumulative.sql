\echo '\n**TESTING**\n'

\echo '\nnew_tests values from testing\n'
SELECT new_tests FROM testing WHERE date >= '2020-03-30' and date <= '2020-04-05' and country_name = 'France';
\echo '\nCumulative values from testing\n'
SELECT * FROM cumulativeTesting('new_tests',date_lower:='2020-03-30',date_upper:='2020-04-05',country:='France');

\echo '\n**VACCINATION EUROPE**\n'

\echo '\nfully_vaccinated values from vaccination_europe\n'
SELECT fully_vaccinated FROM vaccination_europe WHERE date >= '2021-03-30' and date <= '2021-04-30' and country_name = 'France' and manufacturer_name = 'AZ' and group_name = 'ALL';
\echo '\nCumulative values from vaccination_europe\n'
SELECT * FROM cumulativeVaccinationEurope('fully_vaccinated',date_lower:='2021-03-30',date_upper:='2021-04-30',country:='France',manufacturer_name:='AZ', group_name:='ALL');

\echo '\n**VACCINATION WORLD**\n'

\echo '\nfully_vaccinated values from vaccination_world\n'
SELECT fully_vaccinated FROM vaccination_world WHERE date >= '2021-01-10' and date <= '2021-01-15' and country_name = 'United Kingdom';
\echo '\nCumulative values from vaccination_world\n'
SELECT * FROM cumulativeVaccinationWorld('fully_vaccinated',date_lower:='2021-01-10',date_upper:='2021-01-15',country:='United Kingdom');

\echo '\n**TRAVEL**\n'

\echo '\ntravel_count values from travel\n'
SELECT travel_count FROM travel WHERE date >= '2021-03-30' and date <= '2021-04-05' and departure_country = 'France' and arrival_country='Italy';
\echo '\nCumulative values from travel\n'
SELECT * FROM cumulativeTravel(date_lower:='2021-03-30',date_upper:='2021-04-05',departure_country:='France',arrival_country:='Italy');

\echo '\n**POLLUTION**\n'

\echo '\nnew_tests values from Pollution_variation\n'
SELECT total_CO2 FROM pollution_variation WHERE date >= '2020-03-30' and date <= '2020-04-03' and country_name = 'France';
\echo '\nCumulative values from Pollution_variation\n'
SELECT * FROM cumulativePollution('Total_CO2',date_lower:='2020-03-30',date_upper:='2020-04-03',country:='France');


