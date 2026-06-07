-- Monthly cohort retention analysis
with customer_cohorts as (
    select
        customer_id,
        date_trunc('month', first_order_date) as cohort_month
    from {{ ref('dim_customers') }}
    where first_order_date is not null
),

monthly_activity as (
    select
        customer_id,
        date_trunc('month', order_date) as activity_month
    from {{ ref('fct_orders') }}
    where status != 'CANCELLED'
),

cohort_activity as (
    select
        c.cohort_month,
        a.activity_month,
        datediff('month', c.cohort_month, a.activity_month) as months_since_first,
        count(distinct a.customer_id) as active_customers
    from customer_cohorts c
    inner join monthly_activity a on c.customer_id = a.customer_id
    group by 1, 2, 3
),

cohort_sizes as (
    select
        cohort_month,
        count(distinct customer_id) as cohort_size
    from customer_cohorts
    group by 1
)

select
    ca.cohort_month,
    cs.cohort_size,
    ca.months_since_first,
    ca.active_customers,
    round(100.0 * ca.active_customers / cs.cohort_size, 1) as retention_pct
from cohort_activity ca
join cohort_sizes cs on ca.cohort_month = cs.cohort_month
order by ca.cohort_month, ca.months_since_first
