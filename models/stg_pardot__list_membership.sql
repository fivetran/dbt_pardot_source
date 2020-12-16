
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
        id as list_membership_id,
        prospect_id,
        list_id,
        created_at as created_timestamp,
        updated_at as updated_timestamp,
        opted_out as has_opted_out,
        _fivetran_synced
    from fields
)

select * from final
