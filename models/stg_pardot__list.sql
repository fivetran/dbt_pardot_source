
with base as (

    select * 
    from {{ ref('stg_pardot__list_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__list_tmp')),
                staging_columns=get_list_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as list_id
    from fields
)

select * from final
