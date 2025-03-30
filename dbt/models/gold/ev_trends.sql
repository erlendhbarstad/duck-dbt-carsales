with raw as (
    select
        date,
        try_cast(total_sales as integer) as total_sales_raw,
        try_cast(electric_cars as integer) as electric_raw,
        try_cast(hybrid_sales as integer) as hybrid_raw,
        try_cast(diesel_sales as integer) as diesel_raw
    from {{ ref('sales_summary_monthly') }}
),

ev_metrics as (
    select
        date,
        total_sales_raw as total_sales,
        electric_raw as electric_sales,
        hybrid_raw as hybrid_sales,
        diesel_raw as diesel_sales,

        electric_raw * 1.0 / nullif(total_sales_raw, 0) as ev_share,
        hybrid_raw * 1.0 / nullif(total_sales_raw, 0) as hybrid_share,
        diesel_raw * 1.0 / nullif(total_sales_raw, 0) as diesel_share,

        electric_raw - lag(electric_raw) over (order by date) as ev_mom_change,
        hybrid_raw - lag(hybrid_raw) over (order by date) as hybrid_mom_change,

        avg(electric_raw) over (order by date rows between 2 preceding and current row) as ev_3mo_avg
    from raw
)

select * from ev_metrics
