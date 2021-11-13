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

country = input("Enter a country from the european union to plot : ")

query = """
    SELECT date, SUM(partially_vaccinated + fully_vaccinated), name
    FROM vaccination_europe INNER JOIN manufacturer ON code = manufacturer_name WHERE country_name = '"""+country+"""' GROUP BY date, name ORDER BY date, name;
    """

# execute the query
cur.execute(query)
# retrieve the whole result set
data = cur.fetchall()

# close cursor and connection
cur.close()
conn.close()

if len(list(zip(*data))) == 0:
    print('Invalid country !')
    exit()


# unpack data in hours (first column) and
# uploads (second column)
date, vaccinations, manufacturer = zip(*data)

df = pd.DataFrame()
df['date'] = date
df['manufacturer'] = manufacturer
df['vaccinations'] = vaccinations
df = df.pivot(index='date',columns=['manufacturer'],values='vaccinations')


plot = df.plot()
plt.xticks(rotation=45)
plt.ylabel('Number of vaccinations')
plt.xlabel("Date")
plt.title('Number of vaccinations per manufacturer in '+country)
plt.tight_layout()

name = 'VaccinationPerManufacturer'+country+'.png'

plt.savefig(name)
print('The graph has been saved as',name)


