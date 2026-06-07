with revenue as (
    select * from {{ ref('fct_revenue') }}
)

select
    date,
    sum(order_count) as total_orders,
    sum(unique_customers) as unique_customers,
    sum(net_revenue) as total_revenue,
    sum(gross_revenue) as gross_revenue,
    sum(total_discounts) as total_discounts,
    sum(refund_amount) as refund_amount,
    {{ safe_divide('sum(net_revenue)', 'sum(order_count)') }} as avg_order_value,
    {{ safe_divide('sum(refund_amount)', 'sum(gross_revenue)') }} as refund_rate,
    avg(new_customer_order_pct) as avg_new_customer_pct
from revenue
group by 1
order by 1 desc
