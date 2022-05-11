{% from "pgbackrest/map.jinja" import pgbackrest with context %}

include:
  - pgbackrest.install

pgbackrest_log_directory:
  file.directory:
    - name: {{ pgbackrest.logs }}
    - user: {{ pgbackrest.user }}
    - group: {{ pgbackrest.group }}
    - mode: 770
    - makedirs: True
    - require:
      - pkg: pgbackrest_pkg

pgbackrest_respository:
  file.directory:
    - name: {{ pgbackrest.repository }}
    - user: {{ pgbackrest.user }}
    - group: {{ pgbackrest.group }}
    - mode: 750
    - makedirs: True
    - require:
      - pkg: pgbackrest_pkg
