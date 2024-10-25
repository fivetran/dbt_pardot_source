
with base as (

    select * 
    from {{ ref('stg_pardot__opportunity_prospect_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__opportunity_prospect_tmp')),
                staging_columns=get_opportunity_prospect_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        /* generate primary key; table doesn't have one */
        {{ dbt_utils.generate_surrogate_key(['opportunity_id','prospect_id']) }} as id,
        
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        /* timestamps */
        updated_at as updated_timestamp,
        _fivetran_synced,

        /* foreign_keys */
        {{ generate_pardot_surrogate_key('opportunity_id') }} as opportunity_id,
        {{ generate_pardot_surrogate_key('prospect_id') }} as prospect_id
        
    from fields
    
)

select * from final
