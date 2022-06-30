{% from "pgbackrest/map.jinja" import pgbackrest with context %}

include:
  - pgbackrest.install

{% if pgbackrest.cron is defined %}

{% for cron_id, cron_config in pgbackrest.cron.items() %}

pgbackrest_cron_{{ cron_id }}:
  cron.present:
    - identifier: {{ cron_id }}
    {% for cron_key, cron_value in cron_config.items() %}
    - {{ cron_key }}: {{ cron_value }}
    {% endfor %}

{% endfor %}

{% endif %}
