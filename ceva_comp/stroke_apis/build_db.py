import sqlite3

conn = sqlite3.connect('app.db')
cursor = conn.cursor()
try:
    cursor.execute("create table texts("
                   "id integer primary key,"
                   "text varchar)")
    with open("texts.txt", "r") as my_file:
        lines = my_file.readlines()

    for count, line in enumerate(lines):
        cursor.execute("insert into texts values(?,?)", (count, line))

except:
    pass
conn.commit()
print(cursor.execute("select * from texts").fetchall())
