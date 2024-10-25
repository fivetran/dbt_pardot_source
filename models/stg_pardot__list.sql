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
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        /* attributes */
        name,
        description,
        title,
        is_crm_visible,
        is_public,
        is_dynamic,
        
        /* timestamps */
        created_at as created_timestamp,
        updated_at as updated_timestamp,
        _fivetran_synced

    from fields

)

select * from final
