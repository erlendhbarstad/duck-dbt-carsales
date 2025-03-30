with source as (
    select 
        "Year",
        "Month",
        Quantity,
        Quantity_YoY,
        "Import",
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
    from {{ source('stg_car_sales', 'sales_by_month') }}
)

select 
    *
from source
