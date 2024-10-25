with base as (

    select * 
    from {{ ref('stg_pardot__visitor_activity_tmp') }}

),

seed_event_types as (

    select *
    from {{ ref('seed__pardot__visitor_activity_types') }}

),

base_fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pardot__visitor_activity_tmp')),
                staging_columns=get_visitor_activity_columns()
            )
        }}
        
    from base
),


base_fields_renamed as (
    
    select 
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        type as visitor_activity_type_id,
        type_name as event_type_name,
        prospect_id,
        list_email_id,
        visitor_id,
        created_at as created_timestamp,
        campaign_id,
        opportunity_id,
        _fivetran_synced,
        email_id
    
    from base_fields

),

joined as (
    
    select * 
    from base_fields_renamed

    left join seed_event_types using (visitor_activity_type_id)

),

final as (

    select 
        /* primary key */
        visitor_activity_id,
        
        /* core attributes */
        pardot_business_unit_abbreviation
        visitor_activity_type,
        event_type_name,
        created_timestamp,
        
        /* timestamps */
        _fivetran_synced,
        
        /* post-union identifiers */
        _dbt_source_relation,
        visitor_activity_schema_specific_id,
        
        /* foreign keys */
        {{ generate_pardot_surrogate_key('campaign_id') }} as campaign_id,
        {{ generate_pardot_surrogate_key('list_email_id') }} as list_email_id,
        {{ generate_pardot_surrogate_key('opportunity_id') }} as opportunity_id,
        {{ generate_pardot_surrogate_key('prospect_id') }} as prospect_id,
        {{ generate_pardot_surrogate_key('visitor_id') }} as visitor_id,
        {{ generate_pardot_surrogate_key('visitor_activity_type_id') }} as visitor_activity_type_id,
        {{ generate_pardot_surrogate_key('email_id') }} as email_id
    
    from joined

)

select * from final