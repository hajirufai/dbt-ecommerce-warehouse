with orders as (
    select * from {{ ref('fct_orders') }}
    where status not in ('CANCELLED')
)

select
    order_date as date,
    country_code,
    payment_method,
    count(distinct order_id) as order_count,
    count(distinct customer_id) as unique_customers,
    sum(gross_amount) as gross_revenue,
    sum(discount_amount) as total_discounts,
    sum(net_amount) as net_revenue,
    sum(case when is_returned then net_amount else 0 end) as refund_amount,
    sum(net_amount) - sum(case when is_returned then net_amount else 0 end) as actual_revenue,
    avg(net_amount) as avg_order_value,
    {{ safe_divide(
        'sum(case when is_first_order then 1 else 0 end)',
        'count(distinct order_id)'
    ) }} as new_customer_order_pct
from orders
group by 1, 2, 3
