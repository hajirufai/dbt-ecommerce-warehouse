with customers as (
    select * from {{ ref('dim_customers') }}
)

select
    acquisition_channel,
    count(*) as customers_acquired,
    sum(lifetime_revenue) as total_revenue,
    avg(lifetime_revenue) as avg_ltv,
    avg(lifetime_order_count) as avg_orders,
    {{ safe_divide(
        'sum(case when customer_segment in (\'active\', \'cooling\') then 1 else 0 end)',
        'count(*)'
    ) }} as retention_rate
from customers
group by 1
order by total_revenue desc
