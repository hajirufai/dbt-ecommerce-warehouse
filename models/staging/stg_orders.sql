with source as (
    select * from {{ source('raw', 'orders') }}
),

cleaned as (
    select
        cast(order_id as varchar) as order_id,
        cast(customer_id as varchar) as customer_id,
        cast(order_date as date) as order_date,
        upper(trim(status)) as status,
        cast(item_count as integer) as item_count,
        round(cast(amount as decimal(10,2)), 2) as gross_amount,
        round(cast(coalesce(discount, 0) as decimal(10,2)), 2) as discount_amount,
        trim(payment_method) as payment_method,
        trim(shipping_method) as shipping_method,
        cast(delivered_date as date) as delivered_date,
        cast(returned_at as timestamp) as returned_at,
        cast(created_at as timestamp) as created_at
    from source
    where order_id is not null
)

select
    *,
    gross_amount - discount_amount as net_amount,
    case when returned_at is not null then true else false end as is_returned,
    case 
        when delivered_date is not null 
        then datediff('day', order_date, delivered_date) 
    end as days_to_deliver
from cleaned
