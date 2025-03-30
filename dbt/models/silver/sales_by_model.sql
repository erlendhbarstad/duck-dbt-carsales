select
    "Year",
    "Month",
    Make,
    Model,
    Quantity,
    Pct as model_market_share,
    make_date("Year", "Month", 1) as date
from {{ ref('bronze_sales_by_model') }}
