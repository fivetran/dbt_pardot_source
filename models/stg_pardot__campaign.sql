
with base as (

    select * 
    from {{ ref('stg_pardot__campaign_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__campaign_tmp')),
                staging_columns=get_campaign_columns()
            )
        }}
        
    from base
    where not coalesce(_fivetran_deleted, false)
),

final as (
    
    select 
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        /* attributes */
        name as campaign_name,
        cost,
        
        /* timestamps */
        _fivetran_deleted,
        _fivetran_synced,
        
        /* foreign keys */
        salesforce_id as campaign_salesforce_id
        
    from fields
)

select * from final
