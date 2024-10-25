{% macro generate_pardot_surrogate_key(pre_union_primary_key)%}
{{ dbt_utils.generate_surrogate_key(['_dbt_source_relation', pre_union_primary_key]) }}
{% endmacro %}