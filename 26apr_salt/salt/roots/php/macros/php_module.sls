# Macro: Enable or disable PHP module

{% macro php_module(name, enable, sapi) -%}
{% if enable %}
enable-php-module-{{ name }}-for-{{ sapi }}:
  cmd.run:
    - name: phpenmod -s {{ sapi }} {{ name }}
    - unless: phpquery -s {{ sapi }} -m {{ name }}
    - require:
      - file: /etc/php/7.0/mods-available/{{ name }}.ini
{% else %}
disable-php-module-{{ name }}-for-{{ sapi }}:
  cmd.run:
    - name: phpdismod -s {{ sapi }} {{ name }}
    - onlyif: phpquery -s {{ sapi }} -m {{ name }}
{% endif %}

{% endmacro %}
