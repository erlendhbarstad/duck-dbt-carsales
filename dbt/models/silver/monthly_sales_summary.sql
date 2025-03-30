select
    "Year",
    "Month",
    Quantity as total_sales,
    Quantity_YoY,
    Import,
    Import_YoY,
    Used,
    Used_YoY,
    Avg_CO2,
    Bensin_Co2,
    Diesel_Co2,
    Quantity_Diesel,
    Diesel_Share,
    Diesel_Share_LY,
    Quantity_Hybrid,
    Quantity_Electric,
    Import_Electric
from {{ ref('bronze_sales_by_month') }}
