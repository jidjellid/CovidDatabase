#!/usr/bin/env python3

import matplotlib.pyplot as plt
import psycopg2

fig = plt.figure()
ax = fig.add_subplot(111)

database = ''
with open('.database', 'r') as file: database = file.readline()

conn = psycopg2.connect(database=database)
# prepare a cursor
cur = conn.cursor()

country = input("Enter the country to plot: ")

query = """
    SELECT pollution_variation.date,pollution_variation.country_name,total_co2
    ,(SELECT SUM(travel_count) as travel_count FROM travel WHERE date = pollution_variation.date AND departure_country = pollution_variation.country_name GROUP BY date,departure_country)
    ,(SELECT gdp_growth_from_previous_quarter FROM economy WHERE economy.date <= pollution_variation.date AND economy.country_name = country_name ORDER BY date DESC LIMIT 1)
    FROM pollution_variation 
    WHERE country_name = '"""+country+"""' ORDER BY date;"""

# execute the query
cur.execute(query)
# retrieve the whole result set
data = cur.fetchall()

# close cursor and connection
cur.close()
conn.close()

if len(list(zip(*data))) == 0:
    print('Invalid country name !')
    exit()


# unpack data in hours (first column) and
# uploads (second column)
date, name, total_co2, travel_count, gdp = zip(*data)

fig, ax = plt.subplots(figsize=(16,9))
ln1 = ax.plot(total_co2, 'r', label='CO2 variation')
ax.set_ylabel('CO2 variation in MT/day')
ax.set_xlabel("Day of the year")
ax.grid()

ax2 = ax.twinx()
ln2 = ax2.plot(travel_count, 'g',label='Flight count')
ax2.set_ylabel('Total flight count')

ax3 = ax.twinx()
ln3 = ax3.plot(gdp, 'b',label='GDP Growth')
ax3.set_ylabel('GDP Growth from previous quarter')

ax3.spines['right'].set_position(('outward', 60))

lns = ln1 + ln2 + ln3
labs = [l.get_label() for l in lns]
ax.legend(lns, labs, loc=0)
fig.suptitle('Correlation between CO2 Variation, departing flights and economic impact of COVID-19 in '+country)

name = 'PollutionTravelPlot'+country+'.png'

plt.savefig(name)
print('The graph has been saved as',name)


