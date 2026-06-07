with source as (
    select * from {{ source('raw', 'customers') }}
),

cleaned as (
    select
        cast(customer_id as varchar) as customer_id,
        trim(first_name) || ' ' || trim(last_name) as full_name,
        lower(trim(email)) as email,
        upper(trim(country_code)) as country_code,
        cast(signup_date as date) as signup_date,
        trim(acquisition_channel) as acquisition_channel,
        cast(created_at as timestamp) as created_at
    from source
    where customer_id is not null
)

select * from cleaned
