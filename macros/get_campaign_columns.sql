{% macro get_campaign_columns() %}

{% set columns = [
    {"name": "_dbt_source_relation", "datatype": dbt.type_string()},
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "cost", "datatype": dbt.type_int()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "salesforce_id", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
