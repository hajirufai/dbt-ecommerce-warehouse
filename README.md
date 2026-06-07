# 📊 E-Commerce Data Warehouse (dbt + DuckDB)

A production-ready analytics data warehouse built with dbt, modeled on the e-commerce domain. Demonstrates dimensional modeling, data quality testing, incremental materialization, and modern analytics engineering patterns.

![dbt](https://img.shields.io/badge/dbt-1.7+-orange?logo=dbt)
![DuckDB](https://img.shields.io/badge/DuckDB-Analytics-yellow?logo=duckdb)
![Python](https://img.shields.io/badge/Python-3.11+-blue?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

## Data Architecture

```
Raw Sources          Staging              Intermediate           Marts
┌──────────┐     ┌──────────────┐     ┌─────────────────┐    ┌──────────────┐
│ orders   │────▶│ stg_orders   │────▶│ int_orders_     │───▶│ fct_orders   │
│ customers│────▶│ stg_customers│     │   enriched      │    │ dim_customers│
│ products │────▶│ stg_products │     │ int_customer_   │    │ dim_products │
│ payments │────▶│ stg_payments │     │   lifetime      │    │ fct_revenue  │
│ sessions │────▶│ stg_sessions │     │ int_product_    │    │ dim_dates    │
│ events   │────▶│ stg_events   │     │   performance   │    │ mrt_daily_kpi│
└──────────┘     └──────────────┘     └─────────────────┘    └──────────────┘
```

## Features

- **Dimensional Modeling**: Star schema with fact and dimension tables
- **Incremental Models**: Efficient processing for large event tables
- **Data Quality**: 50+ dbt tests (unique, not_null, accepted_values, relationships, custom)
- **Custom Macros**: Reusable SQL transformations (date spine, pivot, safe divide)
- **Seed Data**: Sample datasets for development and testing
- **Documentation**: Full column-level docs with dbt docs generate
- **CI/CD Ready**: Pre-commit hooks + GitHub Actions workflow

## Project Structure

```
├── models/
│   ├── staging/                 # 1:1 source cleaning
│   │   ├── stg_orders.sql
│   │   ├── stg_customers.sql
│   │   ├── stg_products.sql
│   │   ├── stg_payments.sql
│   │   └── _staging.yml         # Tests & docs
│   ├── intermediate/            # Business logic
│   │   ├── int_orders_enriched.sql
│   │   ├── int_customer_lifetime.sql
│   │   └── int_product_performance.sql
│   └── marts/
│       ├── core/                # Core business entities
│       │   ├── fct_orders.sql
│       │   ├── dim_customers.sql
│       │   └── dim_products.sql
│       ├── marketing/           # Marketing analytics
│       │   ├── mrt_customer_segments.sql
│       │   └── mrt_channel_attribution.sql
│       └── finance/             # Financial reporting
│           ├── fct_revenue.sql
│           └── mrt_daily_kpi.sql
├── macros/
│   ├── generate_surrogate_key.sql
│   ├── date_spine.sql
│   └── safe_divide.sql
├── seeds/
│   ├── country_codes.csv
│   └── product_categories.csv
├── tests/
│   └── assert_positive_revenue.sql
├── analyses/
│   └── cohort_analysis.sql
├── dbt_project.yml
├── profiles.yml
└── README.md
```

## Quick Start

```bash
# Install
pip install dbt-duckdb

# Clone
git clone https://github.com/HajiMohamedRufai/dbt-ecommerce-warehouse.git
cd dbt-ecommerce-warehouse

# Load seed data
dbt seed

# Run all models
dbt run

# Run tests
dbt test

# Generate docs
dbt docs generate && dbt docs serve
```

## Key Models

### `fct_orders` — Order Fact Table
```sql
SELECT
    order_id,
    customer_id,
    order_date,
    status,
    item_count,
    gross_amount,
    discount_amount,
    net_amount,
    payment_method,
    shipping_method,
    days_to_deliver,
    is_returned
FROM {{ ref('int_orders_enriched') }}
```

### `dim_customers` — Customer Dimension
```sql
SELECT
    customer_id,
    full_name,
    email,
    country,
    signup_date,
    first_order_date,
    most_recent_order_date,
    lifetime_order_count,
    lifetime_revenue,
    customer_segment,  -- 'new', 'active', 'at_risk', 'churned'
    days_since_last_order
FROM {{ ref('int_customer_lifetime') }}
```

### `mrt_daily_kpi` — Daily Business KPIs
```sql
SELECT
    date,
    total_orders,
    total_revenue,
    unique_customers,
    avg_order_value,
    new_customer_count,
    returning_customer_count,
    refund_rate,
    conversion_rate
FROM {{ ref('int_orders_enriched') }}
GROUP BY date
```

## Data Quality

```yaml
# Example test configuration
models:
  - name: fct_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: net_amount
        tests:
          - not_null
          - dbt_utils.accepted_range:
              min_value: 0
      - name: customer_id
        tests:
          - relationships:
              to: ref('dim_customers')
              field: customer_id
```

## Tech Stack

- **dbt Core 1.7+** — Transformation framework
- **DuckDB** — Local analytical database (swap for Snowflake/BigQuery in production)
- **Jinja** — Templating for dynamic SQL
- **YAML** — Configuration, testing, documentation

## License

MIT License — See [LICENSE](LICENSE) for details.

---

*Built by [Haji Mohamed Rufai](https://linkedin.com/in/hajirufai) — Data Engineer & Analytics Engineer*
