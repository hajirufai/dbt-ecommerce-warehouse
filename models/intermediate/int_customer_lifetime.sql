with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

customer_stats as (
    select
        customer_id,
        customer_name,
        customer_email,
        country_code,
        acquisition_channel,
        customer_signup_date as signup_date,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(distinct order_id) as lifetime_order_count,
        sum(net_amount) as lifetime_revenue,
        avg(net_amount) as avg_order_value,
        sum(case when is_returned then 1 else 0 end) as return_count,
        datediff('day', max(order_date), current_date) as days_since_last_order
    from orders
    where status != 'CANCELLED'
    group by 1, 2, 3, 4, 5, 6
),

segmented as (
    select
        *,
        case
            when days_since_last_order <= 30 then 'active'
            when days_since_last_order <= 90 then 'cooling'
            when days_since_last_order <= 180 then 'at_risk'
            else 'churned'
        end as customer_segment,
        case
            when lifetime_revenue >= 1000 then 'high_value'
            when lifetime_revenue >= 300 then 'mid_value'
            else 'low_value'
        end as value_tier,
        {{ safe_divide('return_count', 'lifetime_order_count') }} as return_rate
    from customer_stats
)

select * from segmented
