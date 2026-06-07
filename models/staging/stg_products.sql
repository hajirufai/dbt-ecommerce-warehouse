with source as (
    select * from {{ source('raw', 'products') }}
),

cleaned as (
    select
        cast(product_id as varchar) as product_id,
        trim(product_name) as product_name,
        trim(category) as category,
        trim(subcategory) as subcategory,
        round(cast(price as decimal(10,2)), 2) as price,
        round(cast(cost as decimal(10,2)), 2) as cost,
        cast(is_active as boolean) as is_active,
        cast(created_at as timestamp) as created_at
    from source
    where product_id is not null
)

select
    *,
    price - cost as margin,
    {{ safe_divide('price - cost', 'price') }} as margin_pct
from cleaned
