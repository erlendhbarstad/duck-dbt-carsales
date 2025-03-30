with source as (
    select 
        "Year",
        "Month",
        Make,
        Quantity,
        Pct
    from {{ source('stg_car_sales', 'sales_by_brand') }}
)

select 
    *
from source
