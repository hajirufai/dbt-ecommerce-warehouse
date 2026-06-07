{% macro date_spine(start_date, end_date) %}
    with date_spine as (
        select
            unnest(generate_series(
                cast('{{ start_date }}' as date),
                cast('{{ end_date }}' as date),
                interval '1 day'
            )) as date_day
    )
    select
        date_day as date,
        extract(year from date_day) as year,
        extract(month from date_day) as month,
        extract(dow from date_day) as day_of_week,
        case when extract(dow from date_day) in (0, 6) then true else false end as is_weekend,
        extract(quarter from date_day) as quarter
    from date_spine
{% endmacro %}
