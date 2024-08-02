
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

        /* split list email name to parts */
        {% set list_email_name_parts = range(1, 9) %}
        
        {% for list_email_name_part in list_email_name_parts %}
            null if(
                replace(
                    split_part(
                        replace(name, '(', ' - '), 
                        ' - ', 
                        {{ list_email_name_part }}),
                    ')', 
                    ''
                ),
                '' 
            ) as list_email_name_part_{{ list_email_name_part }},
        {% endfor %}


        /* search parts for segment keywords */
        {% set list_email_name_segment_parts = range(4, 9) %}
        case 
            {% for list_email_name_segment_part in list_email_name_segment_parts %}
            when {{list_email_name_segment_part}} 
                ilike any (  
                    '%all engaged%',
                    '%emergency%',
                    '%prospects%',
                    '%active%',
                    '%lapsed%',
                    '%midlevel%',
                    '%rai%',
                    '%sustainers%',
                    '%urgents%',
                    '%ml%',
                    '%daf%',
                    '%planned%giving%',
                    '%test%'
                )
            then {{list_email_name_segment_part}}
            {% endfor %}
            else null
        end as keyword_found_list_segment,


        {% set keyword_mapping = {
            '%all engaged%': 'All Engaged',
            '%emergency%': 'Emergency',
            '%prospects%': 'Prospects',
            '%active%': 'Active',
            '%lapsed%': 'Lapsed',
            '%midlevel%': 'Midlevel',
            '%ml%': 'Midlevel',
            '%rai%': 'RAI',
            '%sustainers%': 'Sustainers',
            '%urgents%': 'Urgents',
            '%daf%': 'DAF',
            '%planned%giving%': 'Planned Giving',
            '%test%': 'Test'
        } %}

        {% set list_email_name_segment_part_numbers = range(4, 9) %}
        case
            {% for list_email_name_part_number in list_email_name_segment_part_numbers %}
            when list_email_name_part_{{ list_email_name_part_number }} ilike any ({{ keyword_mapping.keys()|join(', ') }})
            then list_email_name_part_{{ list_email_name_part_number }}
            {% endfor %}
            else null
        end as keyword_found_list_segment,

{% for keyword, cleaned_value in keyword_mapping.items() %}
case
    when keyword_found_list_segment ilike {{ keyword }} then {{ cleaned_value }}
    else null
end as list_email_segment_conformed,
{% endfor %}

        /* list email attributes */
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
