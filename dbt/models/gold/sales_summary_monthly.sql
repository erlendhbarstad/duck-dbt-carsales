select
    make_date("Year", "Month", 1) as date,
    total_sales,
    Quantity_YoY as total_sales_yoy,
    Import,
    Import_YoY,
    try_cast(Used as integer) as used_cars,
    try_cast(Used_YoY as integer) as used_yoy,
    Avg_CO2,
    Diesel_Share,
    Diesel_Share_LY,
    try_cast(Quantity_Electric as integer) as electric_cars,
    try_cast(Quantity_Hybrid as integer) as hybrid_sales,
    try_cast(Quantity_Diesel as integer) as diesel_sales
from {{ ref('monthly_sales_summary') }}
