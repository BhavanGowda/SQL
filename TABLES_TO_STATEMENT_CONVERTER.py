# Note : As of this version you will have to execute all tables in the LEETCODE questions separately

# add the table name from the LEETCODE QUESTION
table_name = "Person"

# add the table structure from the LEETCODE QUESTION
table_structure = """-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | item_id       | int     |
-- | buyer_id      | int     |
-- | seller_id     | int     |
-- +---------------+---------+"""

# add the table structure from the LEETCODE QUESTION
table_data = """-- +----------+------------+---------+----------+-----------+
-- | order_id | order_date | item_id | buyer_id | seller_id |
-- +----------+------------+---------+----------+-----------+
-- | 1        | 2019-08-01 | 4       | 1        | 2         |
-- | 2        | 2018-08-02 | 2       | 1        | 3         |
-- | 3        | 2019-08-03 | 3       | 2        | 3         |
-- | 4        | 2018-08-04 | 1       | 4        | 2         |
-- | 5        | 2018-08-04 | 1       | 3        | 4         |
-- | 6        | 2019-08-05 | 2       | 2        | 4         |
-- +----------+------------+---------+----------+-----------+"""

filter_val = ['', 'ColumnName', 'Type']

table_structure = table_structure.replace('\n', '').replace('-', '').replace('+', '').replace(' ', '').split('|')

filtered_structure = list(filter(lambda x : x not in filter_val, table_structure))

table_structure_len = int(len(filtered_structure)/2)

final_create_statement = [' '.join([filtered_structure[2*i], filtered_structure[2*i+1]]) for i in range(table_structure_len)]

type_storer = [filtered_structure[2*i+1] for i in range(table_structure_len)]

table_data = list(filter(lambda x : x != '',table_data.replace('\n', '').replace('-', '').replace('+', '').replace(' ', '').split('|')))
insert_starter = ''.join(["INSERT INTO "+table_name+" ("] + list(', '.join([filtered_structure[2*i] for i in range(table_structure_len)])) + [") VALUES "])

insert_list = []
for i in range(1, int(len(table_data)/table_structure_len)):
    insert_op = []
    for j in range(table_structure_len):
        type_val = filtered_structure[2*j+1]
        data_val = table_data[table_structure_len*i+j]
        if not(type_val.lower().__contains__('varchar')) and not(type_val.lower().__contains__('date')):
            insert_op.append(data_val)
        else:
            if type_val.lower().__contains__('varchar'):
                insert_op.append(("'" + data_val + "'"))
            if type_val.lower().__contains__('date') and len(data_val)>=8:
                insert_op.append(("'" + data_val[0:4] + '-' + data_val[4:6] + '-' + data_val[6:8] + "'"))
    insert_list.append("("+(', '.join(insert_op))+")")


print(''.join(["CREATE TABLE "+table_name+" ("]+[', '.join(final_create_statement)]+[ ");"])) # Create Statement
print(insert_starter + ','.join(insert_list) + ';') # Insert Statements
