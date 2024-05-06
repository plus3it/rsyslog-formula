# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as rsyslog with context %}

include:
  - {{ sls_config_file }}

rsyslog-service-running-service-running:
  service.running:
    - name: {{ rsyslog.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
