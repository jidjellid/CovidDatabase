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
    SELECT date, group_name, SUM(partially_vaccinated + fully_vaccinated)
    FROM vaccination_europe
    WHERE country_name = '"""+country+"""' GROUP BY date, group_name ORDER BY date;"""

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
date, group_name, vaccs = zip(*data)

df = pd.DataFrame()
df['date'] = date
df['group_name'] = group_name
df['vaccs'] = vaccs
df = df.pivot(index='date',columns=['group_name'],values='vaccs')

df = df.drop(columns=['ALL'])

plot = df.plot.area()
plt.xticks(rotation=45)
plt.ylabel('Number of vaccinations per group')
plt.xlabel("Date")
plt.title('Number of vaccinations per group in '+country)
plt.tight_layout()

name = 'VaccinationsPerGroupIn'+country+'.png'

plt.savefig(name)
print('The graph has been saved as',name)


