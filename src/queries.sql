CREATE OR REPLACE FUNCTION cumulativeTesting(toSearch TEXT, date_lower DATE = NULL, date_upper DATE = NULL, country TEXT = NULL) RETURNS TABLE(date date, vals DECIMAL) AS $$
	BEGIN
    	RETURN QUERY EXECUTE format(
        'SELECT testing.date, SUM(SUM(%s)) OVER (ORDER BY testing.date) 
        FROM testing 
        WHERE (testing.date >= $1 OR $1 IS NULL) 
        AND (testing.date <= $2 OR $2 IS NULL) 
        AND (country_name = $3 OR $3 IS NULL) 
        GROUP BY testing.date'
        ,toSearch) using date_lower,date_upper,country;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cumulativeVaccinationEurope(toSearch TEXT, date_lower DATE = NULL, date_upper DATE = NULL, country TEXT = NULL, manufacturer_name TEXT = NULL, group_name TEXT = NULL) RETURNS TABLE(date date, vals DECIMAL) AS $$
	BEGIN
    	RETURN QUERY EXECUTE format(
        'SELECT vaccination_europe.date, SUM(SUM(%s)) OVER (ORDER BY vaccination_europe.date) 
        FROM vaccination_europe 
        WHERE (vaccination_europe.date >= $1 OR $1 IS NULL) 
        AND (vaccination_europe.date <= $2 OR $1 IS NULL) 
        AND (country_name = $3 OR $3 IS NULL) 
        AND (manufacturer_name = $4 OR $4 IS NULL) 
        AND (group_name = $5 OR $5 IS NULL) 
        GROUP BY vaccination_europe.date'
        ,toSearch) using date_lower,date_upper,country,manufacturer_name,group_name;
    END;
$$ LANGUAGE plpgsql;
--SELECT * FROM cumulativeVaccination('total_doses'::TEXT,'2021-04-10'::DATE,'France'::TEXT,'COM'::TEXT,'ALL'::TEXT);

CREATE OR REPLACE FUNCTION cumulativeVaccinationWorld(toSearch TEXT, date_lower DATE = NULL, date_upper DATE = NULL, country TEXT = NULL) RETURNS TABLE(date date, vals DECIMAL) AS $$
	BEGIN
    	RETURN QUERY EXECUTE format(
        'SELECT vaccination_world.date, SUM(SUM(%s)) OVER (ORDER BY vaccination_world.date)
        FROM vaccination_world 
        WHERE (vaccination_world.date >= $1 OR $1 IS NULL) 
        AND (vaccination_world.date <= $2 OR $2 IS NULL) 
        AND (country_name = $3 OR $3 IS NULL)  
        GROUP BY vaccination_world.date'
        ,toSearch) using date_lower,date_upper,country;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION cumulativeTravel(date_lower DATE = NULL, date_upper DATE = NULL, departure_country TEXT = NULL, arrival_country TEXT = NULL) RETURNS TABLE(date date, vals DECIMAL) AS $$
	BEGIN
    	RETURN QUERY EXECUTE format(
        'SELECT travel.date, SUM(SUM(travel_count)) OVER (ORDER BY travel.date)
        FROM travel 
        WHERE (travel.date >= $1 OR $1 IS NULL) 
        AND (travel.date <= $2 OR $1 IS NULL) 
        AND (departure_country = $3 OR $3 IS NULL)
        AND (arrival_country = $4 OR $4 IS NULL)    
        GROUP BY travel.date') using date_lower,date_upper,departure_country,arrival_country;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION cumulativePollution(toSearch TEXT, date_lower date = NULL, date_upper DATE = NULL, country TEXT = NULL) RETURNS TABLE(date date, vals DECIMAL) AS $$
	BEGIN
    	RETURN QUERY EXECUTE format(
        'SELECT pollution_variation.date, SUM(SUM(pollution_total.%s + pollution_variation.%s)) OVER (ORDER BY pollution_variation.date) 
        FROM pollution_variation INNER JOIN pollution_total ON pollution_variation.country_name = pollution_total.country_name
        WHERE (pollution_variation.date >= $1 OR $1 IS NULL) 
        AND (pollution_variation.date <= $2 OR $2 IS NULL) 
        AND (pollution_variation.country_name = $3 OR $3 IS NULL) 
        GROUP BY pollution_variation.date'
        ,toSearch,toSearch) using date_lower,date_upper,country;
    END;
$$ LANGUAGE plpgsql;


--SELECT * FROM (SELECT * FROM cumulativePollution(toSearch:='total_CO2',country:='France')) as pollutionCovid, (SELECT total_CO2*365 as normal_pollution FROM pollution_total WHERE country_name = 'France') as pollutionNormal;


CREATE OR REPLACE FUNCTION insertTesting(
    date DATE,
    country_name TEXT,
    new_tests DECIMAL = 0,
    tests_positive_rate DECIMAL = 0,
    reproduction_rate DECIMAL = 0,
    new_cases DECIMAL = 0,
    current_hospitalized DECIMAL = 0,
    new_deaths DECIMAL = 0,
    current_icu DECIMAL = 0) RETURNS void AS $$
	BEGIN
        IF(country_name NOT IN (SELECT name FROM countries)) THEN
            RAISE '% does not exist in table countries, please add it here first.',country_name;
		END IF;
		IF EXISTS (SELECT * FROM testing WHERE testing.date = $1 AND testing.country_name = $2) THEN
			UPDATE testing SET 
			new_tests = $3
			, tests_positive_rate = $4
			, reproduction_rate = $5
			, new_cases = $6
			, current_hospitalized = $7
			, new_deaths = $8
			, current_icu = $9
			WHERE testing.date = $1 AND testing.country_name = $2;
			RAISE NOTICE 'Values already existed for tuple (%,%), updating the value instead',$1,$2;
        ELSE INSERT INTO testing(date, country_name, new_tests, tests_positive_rate, reproduction_rate, new_cases, current_hospitalized, new_deaths, current_icu)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9);
		END IF;
    END;
$$ LANGUAGE plpgsql;

--SELECT insertTesting('2020-02-08','France',15,16,17,18,19,20,21);
--SELECT * FROM testing WHERE date = '2020-02-08' AND country_name = 'France';

CREATE OR REPLACE FUNCTION insertVaccinationEurope(
    date DATE,
    country_name TEXT,
    manufacturer_name TEXT,
    group_name TEXT,
    partially_vaccinated INT = 0,
    fully_vaccinated INT = 0,
    total_doses INT = 0) RETURNS void AS $$
	BEGIN
        CASE 
			WHEN (country_name NOT IN (SELECT name FROM countries)) THEN
				RAISE '% does not exist in table countries, please add it here first.',country_name;
			WHEN (manufacturer_name NOT IN (SELECT code FROM manufacturer)) THEN
				RAISE '% does not exist in table manufacturer, please add it here first.',manufacturer_name;
			ELSE
		END CASE;
		IF EXISTS (SELECT * FROM vaccination_europe WHERE vaccination_europe.date = $1 AND vaccination_europe.country_name = $2 AND vaccination_europe.manufacturer_name = $3 AND vaccination_europe.group_name = $4) THEN
			UPDATE vaccination_europe SET 
			partially_vaccinated = $5
			, fully_vaccinated = $6
			, total_doses = $7
			WHERE vaccination_europe.date = $1 AND vaccination_europe.country_name = $2 AND vaccination_europe.manufacturer_name = $3 AND vaccination_europe.group_name = $4;
			RAISE NOTICE 'Values already existed for tuple (%,%,%,%), updating the value instead',$1,$2,$3,$4;
        ELSE 
            INSERT INTO vaccination_europe(date, country_name, manufacturer_name, group_name, partially_vaccinated, fully_vaccinated, total_doses)
            VALUES ($1, $2, $3, $4, $5, $6, $7);
		END IF;
    END;
$$ LANGUAGE plpgsql;

--SELECT insertVaccination('2020-02-08','France','AZ','ALL',1,2,3);
--SELECT * FROM vaccination WHERE date = '2020-02-08' AND country_name = 'France' AND manufacturer_name = 'AZ' AND group_name = 'ALL';

