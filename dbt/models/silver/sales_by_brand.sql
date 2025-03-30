select
    "Year",
    "Month",
    Make,
    Quantity,
    Pct as brand_market_share
from {{ ref('bronze_sales_by_brand') }}
