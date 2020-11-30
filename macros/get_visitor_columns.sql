{% macro get_visitor_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "campaign_parameter", "datatype": dbt_utils.type_string()},
    {"name": "content_parameter", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "hostname", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "ip_address", "datatype": dbt_utils.type_string()},
    {"name": "medium_parameter", "datatype": dbt_utils.type_string()},
    {"name": "page_view_count", "datatype": dbt_utils.type_int()},
    {"name": "prospect_id", "datatype": dbt_utils.type_int()},
    {"name": "source_parameter", "datatype": dbt_utils.type_string()},
    {"name": "term_parameter", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
