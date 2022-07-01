{% from "pgbackrest/map.jinja" import pgbackrest with context %}

include:
  - pgbackrest.install

pgbackrest_log_directory:
  file.directory:
    - name: {{ pgbackrest.config.global['log-path'] }}
    - user: {{ pgbackrest.user }}
    - group: {{ pgbackrest.group }}
    - mode: 770
    - makedirs: True
    - require:
      - pkg: pgbackrest_pkg

pgbackrest_config:
  ini.options_present:
    - name: {{ pgbackrest.conf_file }}
    - separator: '='
    - strict: True
    - sections: {{ pgbackrest.config|yaml() }}
    - require:
      - pkg: pgbackrest_pkg

pgbackrest_config_permissions:
  file.managed:
    - name: {{ pgbackrest.conf_file }}
    - user: {{ pgbackrest.user }}
    - group: {{ pgbackrest.group }}
    - mode: 640
    - require:
      - ini: pgbackrest_config

{% for repo in pgbackrest.get('check-repo', ()) %}

pgbackrest_check_repo_{{ repo }}:
  file.directory:
    - name: {{ pgbackrest.config.global['{}-path'.format(repo)] }}
    - user: {{ pgbackrest.user }}
    - group: {{ pgbackrest.group }}
    - mode: 700

{% endfor %}

{% for section in pgbackrest.config %}

{% if 'global:' not in section and section != 'global' %}

{% if pgbackrest['stanza-create'] %}

pgbackrest_stanza_create_{{ section }}:
  cmd.run:
    - name: /usr/local/bin/pgbackrest --log-level-console=detail --stanza={{ section }} stanza-create
    - runas: {{ pgbackrest.user }}
    - cwd: /tmp
    - shell: /bin/sh
    - require:
      - file: pgbackrest_config_permissions

{% endif %}

{% if pgbackrest.check %}

pgbackrest_stanza_check_{{ section }}:
  cmd.run:
    - name: /usr/local/bin/pgbackrest --log-level-console=detail --stanza={{ section }} check
    - runas: {{ pgbackrest.user }}
    - cwd: /tmp
    - shell: /bin/sh
    - require:
      - file: pgbackrest_config_permissions

{% endif %}

{% endif %}

{% endfor %}
