select
    "Year",
    "Month",
    Make,
    Model,
    Quantity,
    Pct as model_market_share
from {{ ref('bronze_sales_by_model') }}
