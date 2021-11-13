\prompt 'Enter the country between commas : ' psqlvar

PREPARE compare_travel_pollution(text) AS
    SELECT pollution_variation.date,pollution_variation.country_name,total_co2,travel_count 
    FROM pollution_variation 
    INNER JOIN (SELECT date, departure_country, SUM(travel_count) as travel_count FROM travel GROUP BY date,departure_country) as my_travel
    ON pollution_variation.date = my_travel.date 
    AND departure_country = country_name  
    WHERE country_name = $1 ORDER BY date;

EXECUTE compare_travel_pollution(:psqlvar);
