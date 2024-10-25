
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
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        /* attributes - partially organized! */
        /* pii */
        email,
        first_name,
        
        /* address */
        address_one,
        address_two,
        annual_revenue,
        city,
        comments,
        company,
        country,
        crm_url,
        department,
        employees,
        fax,
        grade,
        industry,
        
        /* opt-in / out */
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
        recent_interaction,
        salutation,
        score,
        source as prospect_source,
        state,
        territory,
        updated_at as updated_timestamp,
        website,
        years_in_business,
        zip,

        /* timestamps */
        created_at as created_timestamp,
        crm_last_sync,
        _fivetran_deleted,
        _fivetran_synced,
        
        /* pardot foreign keys */
        {{ generate_pardot_surrogate_key('campaign_id') }} as campaign_id,
        {{ generate_pardot_surrogate_key('prospect_account_id') }} as prospect_account_id,
        {{ generate_pardot_surrogate_key('campaign_id') }} as user_id,

        /* salesforce foreign keys */
        crm_account_fid,
        crm_contact_fid,
        crm_lead_fid,
        crm_owner_fid

        {% if var('prospect_passthrough_columns') %}
        , {{ var('prospect_passthrough_columns')|join(',') }}
        {% endif %}
    from fields
)

select * from final