
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
        opportunity_id,
        prospect_id,
        updated_at as updated_timestamp
    from fields
    
)

select * from final
