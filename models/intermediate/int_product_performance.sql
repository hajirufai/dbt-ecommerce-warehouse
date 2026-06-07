with products as (
    select * from {{ ref('stg_products') }}
),

-- In a real setup, we'd join to order line items
-- For this demo, we aggregate product-level metrics

product_metrics as (
    select
        p.*,
        case
            when margin_pct >= 0.5 then 'high_margin'
            when margin_pct >= 0.2 then 'mid_margin'
            else 'low_margin'
        end as margin_tier
    from products p
)

select * from product_metrics
