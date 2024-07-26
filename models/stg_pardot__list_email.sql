
with base as (

    select * 
    from {{ ref('stg_pardot__list_email_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__list_email_tmp')),
                staging_columns=get_list_email_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as list_email_id,
        sent_at as list_email_sent_at,
        name as list_email_name,

        subject as list_email_subject,
        text_message as list_email_message_text,
        client_type as list_email_client_type,
        
        is_deleted as is_deleted_list_email,
        is_paused as is_paused_list_email,
        is_sent as is_sent_list_email,

        created_at as created_timestamp,
        updated_at as updated_timestamp,
        _fivetran_synced
    
    from fields

)

select * from final
