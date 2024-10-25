--creates creates a primary key as [model]_id from a surrogate made of the source relation + pre-union primary key
--returns the _dbt_source_relation and pardot business unit abbreviation extracted from source schema
--renames the original primary key as [model]_schema_specific_id 
{% macro generate_pardot_identifiers(pre_union_primary_key, model_name=none) %}
    {% set model = model_name if model_name else this.name.split('__')[-1] %}
    
    {{ generate_pardot_surrogate_key(pre_union_primary_key) }} as {{ model }}_id,
    _dbt_source_relation,
    
    {{ pre_union_primary_key }} as {{ model }}_schema_specific_id,
    regexp_replace(
        regexp_replace(
            regexp_substr(_dbt_source_relation, 'PARDOT_(_?\\w+)', 1, 1, 'i', 1),
            '^_',
            ''
        ),
        '_',
        ' '
    ) as pardot_business_unit_abbreviation,
{% endmacro %}