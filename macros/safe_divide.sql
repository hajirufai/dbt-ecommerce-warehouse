{% macro safe_divide(numerator, denominator, default=0) %}
    case
        when {{ denominator }} = 0 or {{ denominator }} is null then {{ default }}
        else round(cast({{ numerator }} as double) / cast({{ denominator }} as double), 4)
    end
{% endmacro %}
