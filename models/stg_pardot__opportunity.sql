
with base as (

    select * 
    from {{ ref('stg_pardot__opportunity_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__opportunity_tmp')),
                staging_columns=get_opportunity_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        probability,
        status as opportunity_status,
        stage,
        type as opportunity_type,
        value as amount,
        
        created_at as created_timestamp,
        updated_at as updated_timestamp,
        _fivetran_synced,
        closed_at as closed_timestamp,
        
        campaign_id,
        name as opportunity_name
    from fields

)

select * from final
