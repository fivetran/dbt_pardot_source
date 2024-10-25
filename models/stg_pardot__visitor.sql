
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
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        /* metrics */
        page_view_count,
        
        /* utm attributes */
        campaign_parameter as utm_campaign,
        content_parameter as utm_content,
        medium_parameter as utm_medium,
        source_parameter as utm_source,
        term_parameter as utm_term,
        
        /* timestamp IP attributes */
        hostname,
        ip_address,
        
        /* timestampa */
        created_at as created_timestamp,
        updated_at as updated_timestamp,
        _fivetran_synced,
        
        {{ generate_pardot_surrogate_key('prospect_id') }} as prospect_id
    
    from fields
)

select * from final
