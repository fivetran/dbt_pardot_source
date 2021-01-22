
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

        {% if var('prospect_passthrough_columns') %}
        , {{ var('prospect_passthrough_columns')|join(',') }}
        {% endif %}
        
    from base
    where not coalesce(_fivetran_deleted, false)
),

final as (
    
    select 
        id as prospect_id,
        _fivetran_deleted,
        _fivetran_synced,
        address_one,
        address_two,
        annual_revenue,
        campaign_id,
        city,
        comments,
        company,
        country,
        created_at as created_timestamp,
        crm_account_fid,
        crm_contact_fid,
        crm_last_sync,
        crm_lead_fid,
        crm_owner_fid,
        crm_url,
        department,
        email,
        employees,
        fax,
        first_name,
        grade,
        industry,
        is_do_not_call,
        is_do_not_email,
        is_reviewed,
        is_starred,
        job_title,
        last_activity_at,
        last_name,
        notes,
        opted_out,
        password,
        phone as phone_number,
        prospect_account_id,
        recent_interaction,
        salutation,
        score,
        source as prospect_source,
        state,
        territory,
        updated_at as updated_timestamp,
        user_id,
        website,
        years_in_business,
        zip
        
        {% if var('prospect_passthrough_columns') %}
        , {{ var('prospect_passthrough_columns')|join(',') }}
        {% endif %}
    from fields
)

select * from final