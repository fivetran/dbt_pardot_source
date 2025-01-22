with source as (
    select * 
    from {{ source('box__misc_mm', 'pardot_mmus_list_emails_manual_records') }}
)

select
    /* primary key */
    upper(replace(replace(list_email_manual_record_id,'#'),' ','')::varchar(256)) as list_email_natural_key,

    /* recorded attributes */
    list_email_recorded_topic,
	list_email_recorded_type,
	list_email_recorded_segment,
    list_email_manual_record_year,
	
	/* timestamps */
    _fivetran_synced,
	
    /* foreign key */
    list_email_manual_record_internal_id
	list_email_manual_record_id,
    _line

from source