{% macro parse_business_unit_from_schema('_dbt_source_relation') %}

REGEXP_REPLACE(
    REGEXP_REPLACE(
        REGEXP_SUBSTR({{_dbt_source_relation}}, 'PARDOT_(_?\\w+)', 1, 1, 'i', 1),
        '^_',
        ''
    ),
    '_',
    ' '
)

{% endmacro %}