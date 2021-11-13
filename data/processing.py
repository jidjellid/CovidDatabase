#!/usr/bin/env python3

import pandas as pd

#COVERED TABLES AS OF RIGHT NOW :
#COUNTRY, GROUP, DATE, VACCINATION, COMPANY, TESTING, ECONOMY, TRAVEL

#MISSING TABLES AS OF RIGHT NOW :
#Nonez

# TODO : Add more data from owid-covid-data ?
#Might want to add tests_units from owid-covid-data to testing table

#PRE-INSERTION CLEANUP OPERATIONS

cleanup1 = pd.read_csv("data/owid-covid-data.csv")
cleanup1['new_tests'] = cleanup1['new_tests'].abs()
cleanup1['new_cases'] = cleanup1['new_cases'].abs()
cleanup1['new_deaths'] = cleanup1['new_deaths'].abs()
cleanup1['reproduction_rate'] = cleanup1['reproduction_rate'].abs()
cleanup1 = cleanup1.round(3)

cleanup1.to_csv("data/owid-covid-data_pro.csv", sep=",", index=False)

cleanup2 = pd.read_csv("data/countries.csv")
cleanup2['Country (or dependency)'] = cleanup2['Country (or dependency)'].replace(['Czech Republic (Czechia)'], ['Czechia'])

cleanup3 = pd.read_csv("data/GDP Growth.csv")
cleanup3['Country'] = cleanup3['Country'].replace(['Czech Republic'], ['Czechia'])
cleanup3['Country'] = cleanup3['Country'].replace(['Korea'], ['South Korea'])
cleanup3['Country'] = cleanup3['Country'].replace(['Slovak Republic'], ['Slovakia'])
cleanup3['Country'] = cleanup3['Country'].replace(["China (People's Republic of)"], ['China'])

bad_values = ["G7","G20","NAFTA","OECD - Europe","OECD - Total","Euro area (19 countries)","European Union – 27 countries (from 01/02/2020)"]
cleanup3 = cleanup3[~cleanup3.Country.isin(bad_values)]

cleanup3.to_csv("data/GDP Growth_pro.csv", sep=",", index=False)

cleanup4 = pd.read_csv("data/countries_iso.csv",dtype ='str')
cleanup4['name'] = cleanup4['name'].replace(['Czech Republic'], ['Czechia'])

#INSERTIONS FOR COUNTRIES TABLE

countries1 = cleanup2
countries2 = pd.read_csv("data/owid-covid-data_pro.csv")
countries3 = pd.read_csv("data/share-population-female.csv")

countries2 = countries2[['iso_code','location','stringency_index','extreme_poverty','cardiovasc_death_rate','diabetes_prevalence','female_smokers','male_smokers','handwashing_facilities','hospital_beds_per_thousand','life_expectancy','human_development_index']]
countries2 = countries2.groupby('location').mean().reset_index()

countries3 = countries3[['Entity','Population, female (% of total)']]
countries3 = countries3.groupby('Entity').mean().reset_index()

countries_joined = countries1.merge(countries2, left_on=['Country (or dependency)'], right_on=['location']).drop(columns=['location'])
countries_joined = countries_joined.merge(countries3, left_on=['Country (or dependency)'], right_on=['Entity'],how='left').drop(columns=['Entity'])
countries_joined = countries_joined.round(2)

countries_joined.to_csv("data/countries_joined-pro.csv", sep=",", index=False)

#INSERTIONS FOR COMPANY TABLE

groups = pd.read_csv("data/delivery.csv")
groups = groups['Group'].drop_duplicates()
groups.to_csv("data/Groups-pro.csv", sep=",", index=False)

#INSERTIONS FOR VACCINATION EUROPE TABLE

vaccinations = pd.read_csv("data/delivery.csv",dtype ='str')
vaccinations = vaccinations[['ReportingCountry','Group','Vaccine brand','Week','Doses received','First dose','Second dose']]
vaccinations.drop(vaccinations.tail(1).index,inplace=True)
vaccinations['Week'] = pd.to_datetime(vaccinations.Week+'0', format='%Y-%W%w')
vaccinations = vaccinations.drop_duplicates(subset=['ReportingCountry','Week','Group','Vaccine brand'])
vaccinations.to_csv("data/delivery-pro.csv", sep=",", index=False,na_rep='0')

#INSERTIONS FOR VACCINATION WORLD TABLE

vaccinations_world = pd.read_csv("data/owid-covid-data_pro.csv",dtype ='str')
vacc_countries_world = pd.read_csv("data/delivery.csv")
vacc_countries = pd.read_csv("data/countries_joined-pro.csv")

vaccinations_world = vacc_countries_world.merge(vaccinations_world, left_on=['ReportingCountry'], right_on=['location'],how='right',indicator=True)
vaccinations_world = vaccinations_world[vaccinations_world['_merge']=='right_only']
vaccinations_world = vacc_countries.merge(vaccinations_world, left_on=['Country (or dependency)'], right_on=['location'],how='left')

vaccinations_world = vaccinations_world[['location','date','new_vaccinations','people_fully_vaccinated']]
vaccinations_world['people_fully_vaccinated'] = pd.to_numeric(vaccinations_world['people_fully_vaccinated'], errors='coerce')
vaccinations_world['people_fully_vaccinated'] = vaccinations_world['people_fully_vaccinated'] - vaccinations_world['people_fully_vaccinated'].shift(1)
vaccinations_world['people_fully_vaccinated'] = vaccinations_world['people_fully_vaccinated'].clip(0,None)
vaccinations_world = vaccinations_world.dropna(subset=['date'])
vaccinations_world.to_csv("data/vaccination_world-pro.csv", sep=",", index=False,na_rep='0')


#INSERTIONS FOR TESTING TABLE

vaccinations = pd.read_csv("data/owid-covid-data_pro.csv",dtype ='str')
vacc_countries = pd.read_csv("data/countries_joined-pro.csv")
vaccinations = vacc_countries.merge(vaccinations, left_on=['Country (or dependency)'], right_on=['location'],how='left')
vaccinations = vaccinations[['location','date','new_cases','new_deaths','reproduction_rate','icu_patients','hosp_patients','new_tests','positive_rate']]
vaccinations.to_csv("data/testing-pro.csv", sep=",", index=False,na_rep='0')

#INSERTIONS FOR ECONOMY TABLE

economy = pd.read_csv("data/GDP Growth_pro.csv",dtype ='str')
economy = economy[['Country','TIME','Value']]
economy['TIME'] = pd.to_datetime(economy['TIME'])
economy = economy.drop_duplicates(subset=['Country','TIME'])
economy = economy.round(9)
economy.to_csv("data/economy-pro.csv", sep=",", index=False)

#CREATION AND INSERTION FOR TRAVEL TABLE

# A prepared csv contains the data passed through the following code, due to the
# huge size of the csv files used (6.4GB total), we skipped this part to allow for
# a faster execution. The source data is available in the source file under flights
'''
flights = pd.read_csv("data/flightlist.csv",dtype ='str')
airports = pd.read_csv("data/airports.csv",dtype ='str')
iso = cleanup4
join = pd.read_csv("data/countries_joined-pro.csv",dtype ='str')

iso = iso.merge(join, left_on=['name'], right_on=['Country (or dependency)'])

airports = airports[['iso_country','name','ident']]
flights = flights[['origin','destination','firstseen']]
iso = iso[['code','name']]

airports_joined = airports.merge(iso, left_on=['iso_country'], right_on=['code'])
airports_joined = airports_joined[['name_y','ident']]

flights_merged1 = flights.merge(airports_joined, left_on=['origin'], right_on=['ident'])
flights_merged2 = flights_merged1.merge(airports_joined, left_on=['destination'], right_on=['ident'])

flights_merged2 = flights_merged2[['firstseen','name_y_x','name_y_y']]
flights_merged2['firstseen'] = pd.to_datetime(flights_merged2['firstseen']).dt.date
flights_merged2['Count'] = 1


flights_merged2 = flights_merged2.groupby(['firstseen','name_y_x','name_y_y']).sum().reset_index()
flights_merged2 = flights_merged2.drop(flights_merged2[flights_merged2.name_y_x == 'Unknown or unassigned country'].index)
flights_merged2 = flights_merged2.drop(flights_merged2[flights_merged2.name_y_y == 'Unknown or unassigned country'].index)

flights_merged2['Count'] = flights_merged2['Count'].apply(lambda x: x * 300) #Nombre de voyage * nombre de place dans l'avion

flights_merged2.to_csv("data/flights_merged-pro.csv", sep=",", index=False)
'''
#Placeholder for commented code above
flights = pd.read_csv("data/flightlist.csv",dtype ='str')
flights.to_csv("data/flights_merged-pro.csv", sep=",", index=False)

#CREATION AND INSERTION FOR POLLUTION TABLES

pollution_values = pd.read_csv("data/Pollution_per_day.csv",dtype ='str')
pollution_mean = pd.read_csv("data/Pollution_total.csv",dtype ='str')
pollution_countries = pd.read_csv("data/countries_joined-pro.csv")

pollution_values = pollution_countries.merge(pollution_values, left_on=['Country (or dependency)'], right_on=['REGION_NAME'],how='left')
pollution_mean = pollution_countries.merge(pollution_mean, left_on=['Country (or dependency)'], right_on=['REGION_NAME'],how='left')

pollution_values = pollution_values[['REGION_NAME','DATE','TOTAL_CO2_MED','PWR_CO2_MED','IND_CO2_MED','TRS_CO2_MED','PUB_CO2_MED','RES_CO2_MED','AVI_CO2_MED']]
pollution_mean = pollution_mean[['REGION_NAME','TOTAL_CO2','POWER','INDUSTRY','SURFACE_TRANSPORT','PUBLIC','RESIDENTIAL','AVIATION']]

pollution_values = pollution_values.stack().str.replace(',','.').unstack()
pollution_mean = pollution_mean.stack().str.replace(',','.').unstack()

pollution_values = pollution_values.drop(pollution_values[pollution_values.TOTAL_CO2_MED == '--'].index).drop_duplicates()
pollution_mean = pollution_mean.drop(pollution_mean[pollution_mean.TOTAL_CO2 == '--'].index).drop_duplicates()

pollution_values["DATE"] = pd.to_datetime(pollution_values["DATE"], format='%d/%m/%Y').dt.strftime('%Y-%m-%d')

pollution_values.to_csv("data/Pollution_per_day-pro.csv", sep=",", index=False)
pollution_mean.to_csv("data/Pollution_total-pro.csv", sep=",", index=False)

