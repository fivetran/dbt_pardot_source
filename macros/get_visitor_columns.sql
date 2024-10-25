{% macro get_visitor_columns() %}

{% set columns = [
    {"name": "_dbt_source_relation", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "campaign_parameter", "datatype": dbt.type_string()},
    {"name": "content_parameter", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "hostname", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "ip_address", "datatype": dbt.type_string()},
    {"name": "medium_parameter", "datatype": dbt.type_string()},
    {"name": "page_view_count", "datatype": dbt.type_int()},
    {"name": "prospect_id", "datatype": dbt.type_int()},
    {"name": "source_parameter", "datatype": dbt.type_string()},
    {"name": "term_parameter", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
