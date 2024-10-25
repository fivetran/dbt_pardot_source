
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
        {{generate_surrograte_key('_dbt_source_relation','id')}} as campaign_surrogate_key,
        
        _dbt_source_relation,
        parse_business_unit_from_schema('_dbt_source_relation') as pardot_business_unit_abbreviation,
        
        name as campaign_name,
        cost,
        
        id as campaign_id,
        salesforce_id as campaign_salesforce_id,
        
        _fivetran_deleted,
        _fivetran_synced
    from fields
)

select * from final
