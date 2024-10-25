{% macro get_visitor_activity_columns() %}

{% set columns = [
    {"name": "_dbt_source_relation", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "custom_redirect_id", "datatype": dbt.type_int()},
    {"name": "details", "datatype": dbt.type_string()},
    {"name": "email_id", "datatype": dbt.type_int()},
    {"name": "email_template_id", "datatype": dbt.type_int()},
    {"name": "file_id", "datatype": dbt.type_int()},
    {"name": "form_handler_id", "datatype": dbt.type_int()},
    {"name": "form_id", "datatype": dbt.type_int()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "landing_page_id", "datatype": dbt.type_int()},
    {"name": "list_email_id", "datatype": dbt.type_int()},
    {"name": "multivariate_test_variation_id", "datatype": dbt.type_int()},
    {"name": "opportunity_id", "datatype": dbt.type_string()},
    {"name": "paid_search_ad_id", "datatype": dbt.type_int()},
    {"name": "prospect_id", "datatype": dbt.type_int()},
    {"name": "site_search_query_id", "datatype": dbt.type_int()},
    {"name": "type", "datatype": dbt.type_int()},
    {"name": "type_name", "datatype": dbt.type_string()},
    {"name": "visit_id", "datatype": dbt.type_string()},
    {"name": "visitor_id", "datatype": dbt.type_int()},
    {"name": "visitor_page_view_id", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
