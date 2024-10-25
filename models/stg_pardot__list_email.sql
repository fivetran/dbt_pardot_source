
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
        /* primary key, schema specific id, schema id, extracted business unit */
        {{generate_pardot_identifiers('id')}}
        
        /* basics */
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

        /* natural key */
        /* cleans list email name month names and special characters to produce uniform coding in the style jan01a */
        {% set month_abbreviations = {
            'january': 'jan',
            'february': 'feb',
            'march': 'mar',
            'april': 'apr',
            'may': 'may',
            'june': 'jun',
            'july': 'jul',
            'august': 'aug',
            'september': 'sep',
            'october': 'oct',
            'november': 'nov',
            'december': 'dec'
        }
        %}

        case 
            {% for month_full, month_abbreviated in month_abbreviations.items() %}
            when list_email_name_part_2 ilike '%{{ month_full }}%' 
                then regexp_replace(
                    list_email_name_part_2,
                    '{{ month_full }}', 
                    '{{ month_abbreviated }}',
                    1,0, 'ci')
            {% endfor %}
            else list_email_name_part_2
        end as clean_month_names,
        left(upper(regexp_replace(clean_month_names, '[# ]')),6) as list_email_name_internal_id,


        list_email_name_part_1 as list_email_name_year,
        list_email_name_year||list_email_name_internal_id as list_email_natural_key,


        /* derive list email type from split part 3 */
        list_email_name_part_4 as list_email_name_parsed_topic,

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

        {% set type_keywords = {
            '%fundraising%': 'Fundraising',
            '%cultivation%': 'Cultivation',
            '%advocacy%': 'Advocacy',
            '%engagement%': 'Engagement'
        } %}

        /* cleaned segment value extracted from list email name */
        case
        {% for segment_keyword, segment_conformed in segment_keywords.items() %}
            when list_email_name ilike '{{ segment_keyword }}' then '{{ segment_conformed }}'
        {% endfor %}
            else null
        end as list_email_keyword_segment,

        case
        {% for status_keyword, status_conformed in status_keywords.items() %}
            when list_email_name ilike '{{ status_keyword }}' then '{{ status_conformed }}'
        {% endfor %}
            else null
        end as list_email_keyword_status,

        case
        {% for type_keyword, type_conformed in type_keywords.items() %}
            when list_email_name ilike '{{ type_keyword }}' then '{{ type_conformed }}'
        {% endfor %}
            else null
        end as list_email_keyword_type,

        /* in which parsed string the keyword is found */
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
        
        /* in which parsed name part the keyword is found */
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

        /* timestamps */
        created_at as created_timestamp,
        updated_at as updated_timestamp,
        _fivetran_synced
    
    from fields

)

select * from final
