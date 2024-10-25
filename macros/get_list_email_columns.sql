{% macro get_list_email_columns() %}

{% set columns = [
    {"name": "_dbt_source_relation", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "subject", "datatype": dbt.type_string()},
    {"name": "client_type", "datatype": dbt.type_string()},
    {"name": "sent_at", "datatype": dbt.type_timestamp()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "text_message", "datatype": dbt.type_string()},
    {"name": "is_sent", "datatype": "boolean"},
    {"name": "is_paused", "datatype": "boolean"},
    {"name": "is_deleted", "datatype": "boolean"},
] %}

{{ return(columns) }}

{% endmacro %}
