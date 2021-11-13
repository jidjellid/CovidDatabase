CREATE OR REPLACE FUNCTION transfer_travel() RETURNS TRIGGER AS $$
DECLARE substraction_value numeric(10,0);
    BEGIN
	substraction_value := (NEW.travel_count * ROUND((50 * (1 + cast((39 * random() - 20) as decimal)/100)),0));
    IF(NEW.date >= '2020-04-01' AND NEW.arrival_country != NEW.departure_country AND (SELECT new_tests FROM testing WHERE date = NEW.date AND country_name = NEW.departure_country) > substraction_value) THEN
        UPDATE testing SET new_tests = new_tests - substraction_value WHERE date = NEW.date AND country_name = NEW.departure_country; --ROUND used to add a 20% variation to the passenger count for some randomness
        UPDATE testing SET new_tests = new_tests + substraction_value WHERE date = NEW.date AND country_name = NEW.arrival_country; 
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION countries_female_ratio_default() RETURNS TRIGGER AS $$
BEGIN
    NEW.female_ratio = 50.0;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION block_update() RETURNS TRIGGER AS $$
BEGIN
    IF(DATE_PART('day', NOW() - OLD.date::timestamp) < 15) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Can not update rows after 15 days!';
    END IF;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trig_countries_female_ratio_default ON countries;
CREATE TRIGGER trig_countries_female_ratio_default BEFORE INSERT ON countries
FOR EACH ROW WHEN (NEW.female_ratio IS NULL)
EXECUTE PROCEDURE countries_female_ratio_default();

DROP TRIGGER IF EXISTS transfer_tests ON travel;
CREATE TRIGGER transfer_tests AFTER INSERT ON travel
FOR EACH ROW
EXECUTE PROCEDURE transfer_travel();

DROP TRIGGER IF EXISTS trig_block_update ON vaccination_europe;
CREATE TRIGGER trig_block_update BEFORE UPDATE ON vaccination_europe
FOR EACH ROW
EXECUTE PROCEDURE block_update();

DROP TRIGGER IF EXISTS trig_block_update ON vaccination_world;
CREATE TRIGGER trig_block_update BEFORE UPDATE ON vaccination_world
FOR EACH ROW
EXECUTE PROCEDURE block_update();
