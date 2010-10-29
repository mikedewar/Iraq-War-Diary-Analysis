import csv

# columns to extract
COLUMN_IDS = [0,3,4,5]+range(16,24)+range(25,27)

def write_row(writer,row):
    cols = COLUMN_IDS
    new_row = [row[i].lower() for i in cols]
    writer.writerow(new_row)

csv.register_dialect(   
    'wikileaks', 
    delimiter=',', 
    quoting=csv.QUOTE_ALL,
    escapechar='\\'
)

iraq_fh = open('../data/irq.csv','r')
reader = csv.reader(iraq_fh, dialect="wikileaks")

new_iraq_fh = open('../cache/iraq_cleaned.csv','w')
writer = csv.writer(new_iraq_fh)

# headings
headings = reader.next()
write_row(writer, headings)
ncol = len(headings)

for row in reader:
    if len(row) == ncol:
        write_row(writer,row)
    else:
        print row
    
