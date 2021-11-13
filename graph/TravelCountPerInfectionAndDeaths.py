#!/usr/bin/env python3

import matplotlib.pyplot as plt
import psycopg2
import pandas as pd


fig = plt.figure()
ax = fig.add_subplot(111)

database = ''
with open('.database', 'r') as file: database = file.readline()

conn = psycopg2.connect(database=database)
# prepare a cursor
cur = conn.cursor()

country = input("Enter the country to plot: ")

query = """
    SELECT date, new_cases, new_deaths,
    (SELECT SUM(travel_count) as travel_count FROM travel WHERE date = testing.date AND departure_country = testing.country_name GROUP BY date,departure_country)
    FROM testing
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
date, new_cases, new_deaths, travel_count = zip(*data)

df = pd.DataFrame()
df['date'] = date
df['new_cases'] = new_cases
df['new_deaths'] = new_deaths
df['travel_count'] = travel_count

df['new_cases'] = df['new_cases'].rolling(20).mean()
df['new_deaths'] = df['new_deaths'].rolling(20).mean()
df['travel_count'] = df['travel_count'].rolling(20).mean()


fig, ax = plt.subplots(figsize=(16,9))
ln1 = ax.plot(df['new_cases'], 'r', label='Cases')
ax.set_ylabel('Cases')
ax.set_xlabel("Day of the year")
ax.grid()

ax2 = ax.twinx()
ln2 = ax2.plot(df['new_deaths'], 'g',label='New deaths')
ax2.set_ylabel('New deaths')

ax3 = ax.twinx()
ln3 = ax3.plot(df['travel_count'], 'b',label='Travel count')
ax3.set_ylabel('Travel count')

ax3.spines['right'].set_position(('outward', 60))

lns = ln1 + ln2 + ln3
labs = [l.get_label() for l in lns]
ax.legend(lns, labs, loc=0)
fig.suptitle('Correlation between cases/deaths and departing flights in '+country)



name = 'TravelCountInfection'+country+'.png'

plt.savefig(name)
print('The graph has been saved as',name)


