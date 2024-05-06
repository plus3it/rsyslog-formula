# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rsyslog with context %}

rsyslog-service-clean-service-dead:
  service.dead:
    - name: {{ rsyslog.service.name }}
    - enable: False
