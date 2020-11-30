
with base as (

    select * 
    from {{ ref('stg_pardot__visitor_activity_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__visitor_activity_tmp')),
                staging_columns=get_visitor_activity_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        type_name as event_type_name,
        prospect_id,
        visitor_id,
        created_at as created_timestamp
    from fields
)

select * from final
