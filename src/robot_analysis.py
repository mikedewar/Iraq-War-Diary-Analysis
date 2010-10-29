import re
import csv

csv.register_dialect(   
    'wikileaks', 
    delimiter=',', 
    quoting=csv.QUOTE_ALL,
    escapechar='\\'
)

COLUMN_IDS = [0,3,4,5]+range(16,24)+range(25,27)

def write_row(writer,row):
    cols = COLUMN_IDS
    new_row = [row[i].lower() for i in cols]
    writer.writerow(new_row)

iraq_fh = open('../data/irq.csv','r')
reader = csv.reader(iraq_fh, dialect="wikileaks")

iraq_robots = open('../cache/iraq_robots.csv','w')
writer = csv.writer(iraq_robots)

def terms_are_in(row):
    terms = ["uav","robot","predator","reaper"]
    for term in terms:
        if term in row[8]:
            return True
    return False


headings = reader.next()
write_row(writer, headings)
ncol = len(headings)

for row in reader:
    if len(row) == ncol:
        if terms_are_in(row):
            print row
            write_row(writer,row)