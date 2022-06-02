{% set event_types = dbt_utils.get_column_values(ref('stg_heroku_postgres_events'),'event_type') %}
WITH stg_events AS (
    SELECT *
    FROM {{ ref('stg_heroku_postgres_events') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        {%- for event_type in event_types %}
        sum(case when event_type = '{{event_type}}' then 1 end) as {{event_type}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    FROM stg_events
    GROUP BY 1
    )
    
SELECT * FROM renamed_casted