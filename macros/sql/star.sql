{% macro star(from, except=[]) -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- if from.name -%}
        {%- set schema_name, table_name = from.schema, from.name -%}
    {%- else -%}
        {%- set schema_name, table_name = (from | string).split(".") -%}
    {%- endif -%}

    {%- set include_cols = [] %}
    {%- set cols = adapter.get_columns_in_table(schema_name, table_name) -%}
    {%- for col in cols -%}

        {%- if col.column not in except -%}
            {% set _ = include_cols.append(col.column) %}

        {%- endif %}
    {%- endfor %}

    {%- for col in include_cols %}

        "{{ col }}" {% if not loop.last %},
        {% endif %}

    {%- endfor -%}
{%- endmacro %}
