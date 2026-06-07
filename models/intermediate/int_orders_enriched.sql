with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

payments as (
    select
        order_id,
        sum(case when payment_status = 'SUCCESS' then amount else 0 end) as paid_amount,
        count(*) as payment_attempts,
        max(processed_at) as last_payment_at
    from {{ ref('stg_payments') }}
    group by order_id
),

enriched as (
    select
        o.*,
        c.full_name as customer_name,
        c.email as customer_email,
        c.country_code,
        c.acquisition_channel,
        c.signup_date as customer_signup_date,
        p.paid_amount,
        p.payment_attempts,
        p.last_payment_at,
        datediff('day', c.signup_date, o.order_date) as days_since_signup,
        row_number() over (
            partition by o.customer_id 
            order by o.order_date
        ) as customer_order_number
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join payments p on o.order_id = p.order_id
)

select * from enriched
