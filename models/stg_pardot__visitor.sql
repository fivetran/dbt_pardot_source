
with base as (

    select * 
    from {{ ref('stg_pardot__visitor_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__visitor_tmp')),
                staging_columns=get_visitor_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as visitor_id,
        prospect_id,
        created_at as created_timestamp,
        page_view_count
    from fields
)

select * from final
