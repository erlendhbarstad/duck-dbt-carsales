duckdb;
show tables;

select * from read_csv_auto('../data/norway_new_car_sales_by_make.csv') limit 10;
select * from read_csv_auto('../data/norway_new_car_sales_by_month.csv') limit 10;
select * from read_csv_auto('../data/norway_new_car_sales_by_model.csv') limit 10;

create table  new_car_sales_by_model as from read_csv_auto('../data/norway_new_car_sales_by_model.csv');

.describe new_car_sales_by_model

.timer on
select * from new_car_sales_by_model limit 500;
-- Run Time (s): real 0.006 user 0.003103 sys 0.001164
.database

.exit


-- check our new db:
duckdb;
.open ../car_sales.ddb
.database
.schema
.tables
select * from stg.sales_by_brand limit 10;
.exit

-- open UI:
duckdb car_sales.ddb -ui;