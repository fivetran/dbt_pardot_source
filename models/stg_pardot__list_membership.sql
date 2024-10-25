
with base as (

    select * 
    from {{ ref('stg_pardot__list_membership_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__list_membership_tmp')),
                staging_columns=get_list_membership_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        /* attributes */
        opted_out as has_opted_out,
        
        /* timestamps */
        created_at as created_timestamp,
        updated_at as updated_timestamp,
        _fivetran_synced,

        /* foreign keys */
        prospect_id,
        list_id
        
    from fields
)

select * from final
