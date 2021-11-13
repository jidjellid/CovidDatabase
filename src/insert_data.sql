-- Countries
\copy countries(name, population, yearly_change, net_change, density, land_area, migrants, fert_rate, med_age, urban_population, world_share, stringency_index, extreme_poverty, cardiovasc_death_rate,diabetes_prevalence, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy, hdi, female_ratio) FROM 'data/countries_joined-pro.csv' DELIMITER ',' CSV HEADER;

-- Manufacturer
\copy manufacturer(name, code, shelf_life) FROM 'data/manufacturer.csv' DELIMITER ',' CSV HEADER;

-- Vaccinations europe
\copy vaccination_europe(country_name, group_name, manufacturer_name, date, total_doses, partially_vaccinated, fully_vaccinated) FROM 'data/delivery-pro.csv' DELIMITER ',' CSV HEADER;

-- Vaccinations rest of the world
\copy vaccination_world(country_name, date, partially_vaccinated, fully_vaccinated) FROM 'data/vaccination_world-pro.csv' DELIMITER ',' CSV HEADER;

-- Testing
\copy testing(country_name, date, new_cases, new_deaths, reproduction_rate, current_icu, current_hospitalized, new_tests, tests_positive_rate) FROM 'data/testing-pro.csv' DELIMITER ',' CSV HEADER;

-- Economy
\copy economy(country_name, date, gdp_growth_from_previous_quarter) FROM 'data/economy-pro.csv' DELIMITER ',' CSV HEADER;

--Travel
\copy travel(date,departure_country,arrival_country,travel_count) FROM 'data/flights_merged-pro.csv' DELIMITER ',' CSV HEADER;

--Pollution_variation - Valeurs en MT/jour
\copy pollution_variation(country_name,date,total_CO2,power_CO2,industry_CO2,transport_CO2,publicSector_CO2,residential_CO2,aviation_CO2) FROM 'data/Pollution_per_day-pro.csv' DELIMITER ',' CSV HEADER;

--Pollution_total
\copy pollution_total(country_name,total_CO2,power_CO2,industry_CO2,transport_CO2,publicSector_CO2,residential_CO2,aviation_CO2) FROM 'data/Pollution_total-pro.csv' DELIMITER ',' CSV HEADER;
