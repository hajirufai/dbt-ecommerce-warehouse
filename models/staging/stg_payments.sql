with source as (
    select * from {{ source('raw', 'payments') }}
),

cleaned as (
    select
        cast(payment_id as varchar) as payment_id,
        cast(order_id as varchar) as order_id,
        upper(trim(payment_method)) as payment_method,
        upper(trim(status)) as payment_status,
        round(cast(amount as decimal(10,2)), 2) as amount,
        cast(processed_at as timestamp) as processed_at,
        cast(created_at as timestamp) as created_at
    from source
    where payment_id is not null
)

select * from cleaned
