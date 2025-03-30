import streamlit as st
import duckdb
import pandas as pd
import plotly.express as px
import os

# Connect to DuckDB
base_dir = os.path.dirname(__file__)
db_path = os.path.join(base_dir, "..", "car_sales.ddb")
con = duckdb.connect(db_path)

st.title("🚗 Car Sales Dashboard")

# ---- Load Data ----
ev = con.execute("SELECT * FROM gold.ev_trends ORDER BY date").df()
brands = con.execute("SELECT * FROM gold.monthly_trends ORDER BY date").df()
models = con.execute("SELECT * FROM gold.model_performance_snapshot ORDER BY model_rank").df()

# ---- Sidebar Filters ----
st.sidebar.header("Filters")
brand_filter = st.sidebar.multiselect("Select Brands", sorted(brands['brand'].unique()), default=brands['brand'].unique()[:5])
date_range = st.sidebar.slider("Select Date Range", 
                               min_value=brands['date'].min().to_pydatetime(), 
                               max_value=brands['date'].max().to_pydatetime(),
                               value=(brands['date'].min().to_pydatetime(), brands['date'].max().to_pydatetime()))

# ---- EV Trend ----
st.subheader("⚡ EV Sales Over Time")
ev_filtered = ev[(ev['date'] >= pd.to_datetime(date_range[0])) & (ev['date'] <= pd.to_datetime(date_range[1]))]
fig_ev = px.line(ev_filtered, x="date", y=["electric_sales", "hybrid_sales", "diesel_sales"], title="EV, Hybrid, Diesel Sales")
st.plotly_chart(fig_ev, use_container_width=True)

# ---- Brand Trends ----
st.subheader("🏷️ Brand Sales Trends")
brands_filtered = brands[
    (brands['brand'].isin(brand_filter)) &
    (brands['date'] >= pd.to_datetime(date_range[0])) &
    (brands['date'] <= pd.to_datetime(date_range[1]))
]
fig_brand = px.line(brands_filtered, x="date", y="sales", color="brand", title="Brand Sales Over Time")
st.plotly_chart(fig_brand, use_container_width=True)

# ---- Top Models ----
st.subheader("🏆 Top Models (Latest Month)")
fig_model = px.bar(models.head(10), x="Model", y="sales", color="brand", title="Top 10 Models")
st.plotly_chart(fig_model, use_container_width=True)

# ---- Most Sold Model (Filtered) ----
st.subheader("👑 Most Sold Model (Filtered)")

# Load silver model data
models = con.execute("""
    SELECT 
        "Year" as year,
        "Month" as month,
        Make AS brand,
        Model as model,
        Quantity as sales,
        model_market_share,
        date
    FROM silver.sales_by_model
""").df()

# Ensure datetime type
models['date'] = pd.to_datetime(models['date'])
models['brand'] = models['brand'].str.strip()

# Normalize casing if needed
models['brand_lower'] = models['brand'].str.lower()
brand_filter_lower = [b.lower() for b in brand_filter]

# Filter
models_filtered = models[
    (models['brand_lower'].isin(brand_filter_lower)) &
    (models['date'] >= pd.to_datetime(date_range[0])) &
    (models['date'] <= pd.to_datetime(date_range[1]))
]

if not models_filtered.empty:
    # Aggregate total sales per model
    model_totals = (
        models_filtered
        .groupby(['brand', 'model'], as_index=False)
        .agg({'sales': 'sum'})
        .sort_values(by='sales', ascending=False)
    )

    # Show top 1 model
    top_model = model_totals.iloc[0]

    st.markdown(f"""
    ### 🏆 **{top_model['brand']} {top_model['model']}**
    Total Sales: **{top_model['sales']}**
    """)

    # Bar chart of top 10 models
    fig_top = px.bar(
        model_totals.head(10),
        x='model',
        y='sales',
        color='brand',
        title='Top Selling Models by Filter',
        text='sales'
    )
    st.plotly_chart(fig_top, use_container_width=True)

else:
    st.warning("No models found for the selected filters.")
    st.info("Try adjusting the date range or brand selection.")
