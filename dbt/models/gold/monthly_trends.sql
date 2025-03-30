select
    make as brand,
    make_date("Year", "Month", 1) as date,
    quantity as sales,
    lag(quantity) over (partition by make order by "Year", "Month") as sales_last_month,
    quantity - lag(quantity) over (partition by make order by "Year", "Month") as sales_mom_change,
    brand_market_share
from {{ ref('sales_by_brand') }}
