{%- macro get_node_values() -%}
    {{ return(adapter.dispatch('get_node_values', 'dbt_project_evaluator')()) }}
{%- endmacro -%}

{%- macro default__get_node_values() -%}

    {%- if execute -%}
    {%- set nodes_list = graph.nodes.values() -%}
    {%- set values = [] -%}

    {%- for node in nodes_list -%}

        {%- set values_line  = 
            [
                wrap_string_with_quotes(node.unique_id),
                wrap_string_with_quotes(node.name),
                wrap_string_with_quotes(node.resource_type),
                wrap_string_with_quotes(node.original_file_path | replace("\\","\\\\")),
                "cast(" ~ node.config.enabled | trim ~ " as boolean)",
                wrap_string_with_quotes(node.config.materialized),
                wrap_string_with_quotes(node.config.on_schema_change),
                wrap_string_with_quotes(node.database),
                wrap_string_with_quotes(node.schema),
                wrap_string_with_quotes(node.package_name),
                wrap_string_with_quotes(node.alias),
                "cast(" ~ dbt_project_evaluator.is_not_empty_string(node.description) | trim ~ " as boolean)",
                "''" if not node.column_name else wrap_string_with_quotes(dbt.escape_single_quotes(node.column_name)),
                wrap_string_with_quotes(node.meta | tojson)
            ]
        %}

        {%- do values.append(values_line) -%}

    {%- endfor -%}
    {%- endif -%}

    {{ return(values) }}

{%- endmacro -%}
