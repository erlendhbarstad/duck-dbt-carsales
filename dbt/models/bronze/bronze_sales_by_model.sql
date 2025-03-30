with source as (
    select 
        "Year",
        "Month",
        Make,
        Model,
        Quantity,
        Pct
    from {{ source('stg_car_sales', 'sales_by_model') }}
)

select 
    *
from source
