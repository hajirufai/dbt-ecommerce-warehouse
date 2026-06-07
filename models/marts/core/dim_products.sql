with products as (
    select * from {{ ref('int_product_performance') }}
)

select
    product_id,
    product_name,
    category,
    subcategory,
    price,
    cost,
    margin,
    margin_pct,
    margin_tier,
    is_active,
    created_at,
    current_timestamp as _loaded_at
from products
