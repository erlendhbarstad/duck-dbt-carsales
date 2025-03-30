import duckdb
import os

con = duckdb.connect(os.path.expanduser("../car_sales.ddb"))
con.execute("CREATE SCHEMA IF NOT EXISTS stg")

con.execute(f"""
    CREATE TABLE stg.sales_by_brand AS
    SELECT * FROM read_csv_auto('../data/norway_new_car_sales_by_make.csv')
""")
con.execute(f"""
    CREATE TABLE stg.sales_by_model AS
    SELECT * FROM read_csv_auto('../data/norway_new_car_sales_by_model.csv')
""")
con.execute(f"""
    CREATE TABLE stg.sales_by_month AS
    SELECT * FROM read_csv_auto('../data/norway_new_car_sales_by_month.csv')
""")