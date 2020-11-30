
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
),

final as (
    
    select 
        id as campaign_id,
        name as campaign_name,
        cost
    from fields
)

select * from final
