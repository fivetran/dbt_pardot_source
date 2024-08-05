
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
            nullif(
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

        /* validate whether the email name has mmus formatting, defined: first split part of the name is a year on or after 2022 */    
        case
            when try_cast(list_email_name_part_1 as integer) >= 2022
            then true
            else false
        end as is_mmus_formated_list_email_name,
        case when list_email_name ilike any ('%test%') then true else false end as is_test,

        /* derive list email type from split part 3 */
        list_email_name_part_3 as list_email_name_part_type,

        /* list email segment - special logic to extract conformed attribute from name */
        {% set segment_keywords = {
            '%all%engaged%': 'All Engaged',
            '%emergency%': 'Emergency',
            '%midlevel%': 'Midlevel',
            '%ml%': 'Midlevel',
            'rai': 'RAI',
            '%sustainers%': 'Sustainers',
            '%urgents%': 'Urgents',
            '%daf%': 'DAF',
            '%planned%giving%': 'Planned Giving',
        } %}

        {% set status_keywords = {
            '%prospects%': 'Prospects',
            '%prospects%': 'Currents',
            '%active%': 'Active',
            '%lapsed%': 'Lapsed',
        } %}

        /* cleaned segment value extracted from list email name */
        case
        {% for keyword, cleaned_value in segment_keywords.items() %}
            when list_email_name ilike '{{ keyword }}' then '{{ cleaned_value }}'
        {% endfor %}
            else null
        end as list_email_keyword_found_segment,

        /* in which parsed string,list_email_name_part_{{ list_email_name_part_number }}, the keyword is found */
        {% set list_email_name_segment_part_numbers = range(4, 9) %}
        case
            {%- for list_email_name_part_number in list_email_name_segment_part_numbers %}
            when list_email_name_part_{{ list_email_name_part_number }} 
                ilike any (
                    {%- for keyword in segment_keywords.keys() %}
                    '{{ keyword }}'{% if not loop.last %},{% endif %}
                    {%- endfor -%}
                )
            then list_email_name_part_{{ list_email_name_part_number }}
            {%- endfor %}
            else null
        end as segment_keyword_found_string,

       case
            {% for list_email_name_part_number in list_email_name_segment_part_numbers %}
            when list_email_name_part_{{ list_email_name_part_number }} 
                ilike any (
                    {%- for keyword in segment_keywords.keys() %}
                    '{{ keyword }}'{% if not loop.last %},{% endif %}
                    {%- endfor -%}
                )
            then 'list_email_name_part_{{ list_email_name_part_number }}'
            {% endfor %}
            else null
        end as segment_keyword_found_in_list_email_name_part,

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
