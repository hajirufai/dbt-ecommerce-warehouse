-- Revenue should never be negative
select
    order_id,
    net_amount
from {{ ref('fct_orders') }}
where net_amount < 0
