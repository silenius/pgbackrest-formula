{% from "pgbackrest/map.jinja" import pgbackrest with context %}

pgbackrest_pkg:
  pkg.installed:
    - name: {{ pgbackrest.pkg }}
