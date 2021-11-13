DROP TABLE IF EXISTS countries CASCADE;
CREATE TABLE countries(
    name VARCHAR(108),
    population INT NOT NULL CHECK(population >= 0),
    yearly_change DECIMAL NOT NULL,
    net_change INT NOT NULL,
    density INT NOT NULL CHECK(density >= 0),
    land_area INT NOT NULL CHECK(land_area >= 0),
    migrants DECIMAL, 
    fert_rate DECIMAL CHECK(fert_rate >= 0),
    med_age DECIMAL CHECK(med_age >= 0), 
    urban_population DECIMAL CHECK(urban_population >= 0),
    world_share DECIMAL NOT NULL CHECK(world_share >= 0),
    stringency_index DECIMAL CHECK(stringency_index >= 0),
    extreme_poverty DECIMAL CHECK(extreme_poverty >= 0),
    cardiovasc_death_rate DECIMAL CHECK(cardiovasc_death_rate >= 0),
    diabetes_prevalence DECIMAL CHECK(diabetes_prevalence >= 0),
    female_smokers DECIMAL CHECK(female_smokers >= 0),
    male_smokers DECIMAL CHECK(male_smokers >= 0),
    handwashing_facilities DECIMAL CHECK(handwashing_facilities >= 0),
    hospital_beds_per_thousand DECIMAL CHECK(hospital_beds_per_thousand >= 0),
    life_expectancy DECIMAL CHECK(life_expectancy >= 0),
    hdi DECIMAL CHECK(hdi >= 0),
    female_ratio DECIMAL CHECK(female_ratio >= 0),
    PRIMARY KEY (name)
);

DROP TABLE IF EXISTS manufacturer CASCADE;
CREATE TABLE manufacturer(
    name VARCHAR(108),
    code VARCHAR(10) UNIQUE,
    shelf_life INT NOT NULL CHECK(shelf_life >= 0),
    PRIMARY KEY (name)
);

DROP TABLE IF EXISTS travel CASCADE;
CREATE TABLE travel(
    departure_country VARCHAR(108),
    arrival_country VARCHAR(108),
    date DATE,
    travel_count INT NOT NULL CHECK(travel_count >= 0),
    PRIMARY KEY (departure_country, arrival_country, date),
    FOREIGN KEY (departure_country) REFERENCES countries(name),
    FOREIGN KEY (arrival_country) REFERENCES countries(name)
);

DROP TABLE IF EXISTS economy CASCADE;
CREATE TABLE economy(
    date DATE,
    country_name VARCHAR(108),
    gdp_growth_from_previous_quarter DECIMAL NOT NULL,
    PRIMARY KEY (date, country_name),
    FOREIGN KEY (country_name) REFERENCES countries(name)
);

DROP TABLE IF EXISTS vaccination_europe CASCADE;
CREATE TABLE vaccination_europe(
    date DATE,
    country_name VARCHAR(108),
    manufacturer_name VARCHAR(108),
    group_name VARCHAR(108),
    partially_vaccinated INT CHECK(partially_vaccinated >= 0),
    fully_vaccinated INT CHECK(fully_vaccinated >= 0),
    total_doses INT CHECK(total_doses >= 0),
    PRIMARY KEY (country_name,date,manufacturer_name,group_name),
    FOREIGN KEY (country_name) REFERENCES countries(name),
    FOREIGN KEY (manufacturer_name) REFERENCES manufacturer(code)
);

DROP TABLE IF EXISTS vaccination_world CASCADE;
CREATE TABLE vaccination_world(
    date DATE,
    country_name VARCHAR(108),
    partially_vaccinated DECIMAL CHECK(partially_vaccinated >= 0),
    fully_vaccinated DECIMAL CHECK(fully_vaccinated >= 0),
    PRIMARY KEY (country_name,date),
    FOREIGN KEY (country_name) REFERENCES countries(name)
);

DROP TABLE IF EXISTS testing CASCADE;
CREATE TABLE testing(
    date DATE,
    country_name VARCHAR(108),
    new_tests DECIMAL CHECK(new_tests >= 0),
    tests_positive_rate DECIMAL CHECK(tests_positive_rate >= 0 AND tests_positive_rate <= 100),
    reproduction_rate DECIMAL CHECK(reproduction_rate >= 0),
    new_cases DECIMAL CHECK(new_cases >= 0),
    current_hospitalized DECIMAL CHECK(current_hospitalized >= 0),
    new_deaths DECIMAL CHECK(new_deaths >= 0),
    current_icu DECIMAL CHECK(current_icu >= 0),
    PRIMARY KEY (country_name,date),
    FOREIGN KEY (country_name) REFERENCES countries(name)
);

DROP TABLE IF EXISTS pollution_variation CASCADE;
CREATE TABLE pollution_variation(
    date DATE,
    country_name VARCHAR(108),
    total_CO2 DECIMAL,
    power_CO2 DECIMAL,
    industry_CO2 DECIMAL,
    transport_CO2 DECIMAL,
    publicSector_CO2 DECIMAL,
    residential_CO2 DECIMAL,
    aviation_CO2 DECIMAL,
    PRIMARY KEY (country_name,date),
    FOREIGN KEY (country_name) REFERENCES countries(name)
);

DROP TABLE IF EXISTS pollution_total CASCADE;
CREATE TABLE pollution_total(
    country_name VARCHAR(108),
    total_CO2 DECIMAL,
    power_CO2 DECIMAL,
    industry_CO2 DECIMAL,
    transport_CO2 DECIMAL,
    publicSector_CO2 DECIMAL,
    residential_CO2 DECIMAL,
    aviation_CO2 DECIMAL,
    PRIMARY KEY (country_name),
    FOREIGN KEY (country_name) REFERENCES countries(name)
);

CREATE INDEX total_CO2_variation_index ON Pollution_variation(total_CO2);
CREATE INDEX total_CO2_total_index ON Pollution_total(total_CO2);
CREATE INDEX travel_count_index ON Travel(travel_count);
CREATE INDEX population_index ON Countries(population);