
with base as (

    select * 
    from {{ ref('stg_pardot__prospect_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__prospect_tmp')),
                staging_columns=get_prospect_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as prospect_id,
        first_name,
        last_name,
        email,
        campaign_id
    from fields
)

select * from final