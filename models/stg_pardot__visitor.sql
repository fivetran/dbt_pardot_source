
with base as (

    select * 
    from {{ ref('stg_pardot__visitor_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__visitor_tmp')),
                staging_columns=get_visitor_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        {{generate_surrograte_key('_dbt_source_relation','id')}} as visitor_surrogate_key,
        
        _dbt_source_relation,
        parse_business_unit_from_schema('_dbt_source_relation') as pardot_business_unit_abbreviation,
        
        id as visitor_id,
        prospect_id,
        created_at as created_timestamp,
        page_view_count,
        _fivetran_synced,
        campaign_parameter as utm_campaign,
        content_parameter as utm_content,
        hostname,
        ip_address,
        medium_parameter as utm_medium,
        source_parameter as utm_source,
        term_parameter as utm_term,
        updated_at as updated_timestamp
    from fields
)

select * from final
