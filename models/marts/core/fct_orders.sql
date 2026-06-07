{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

with enriched_orders as (
    select * from {{ ref('int_orders_enriched') }}
    {% if is_incremental() %}
    where created_at > (select max(created_at) from {{ this }})
    {% endif %}
)

select
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
    is_returned,
    customer_order_number,
    case when customer_order_number = 1 then true else false end as is_first_order,
    paid_amount,
    payment_attempts,
    country_code,
    acquisition_channel,
    created_at
from enriched_orders
