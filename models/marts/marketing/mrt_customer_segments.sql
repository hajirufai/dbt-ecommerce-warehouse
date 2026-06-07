with customers as (
    select * from {{ ref('dim_customers') }}
)

select
    customer_segment,
    value_tier,
    acquisition_channel,
    count(*) as customer_count,
    avg(lifetime_revenue) as avg_ltv,
    avg(lifetime_order_count) as avg_orders,
    avg(days_since_last_order) as avg_recency,
    sum(lifetime_revenue) as total_revenue,
    {{ safe_divide(
        'sum(case when customer_segment = \'active\' then 1 else 0 end)',
        'count(*)'
    ) }} as active_rate
from customers
group by 1, 2, 3
