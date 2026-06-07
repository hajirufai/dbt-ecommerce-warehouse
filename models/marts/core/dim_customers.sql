with customer_lifetime as (
    select * from {{ ref('int_customer_lifetime') }}
)

select
    customer_id,
    customer_name as full_name,
    customer_email as email,
    country_code,
    acquisition_channel,
    signup_date,
    first_order_date,
    most_recent_order_date,
    lifetime_order_count,
    lifetime_revenue,
    avg_order_value,
    return_count,
    return_rate,
    days_since_last_order,
    customer_segment,
    value_tier,
    current_timestamp as _loaded_at
from customer_lifetime
