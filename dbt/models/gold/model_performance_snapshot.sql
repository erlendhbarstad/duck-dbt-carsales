with base as (
    select
        *,
        make_date("Year", "Month", 1) as date
    from {{ ref('sales_by_model') }}
),

latest as (
    select max(date) as latest_date from base
)

select
    b.date,
    b.make as brand,
    b.model,
    b.quantity as sales,
    b.model_market_share,
    row_number() over (order by b.quantity desc) as model_rank
from base b
join latest l on b.date = l.latest_date
