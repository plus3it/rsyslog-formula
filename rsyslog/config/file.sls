# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as rsyslog with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set loghost_list = salt.pillar.get('rsyslog:lookup:remote_loghosts', []) %}

include:
  - {{ sls_package_install }}

{%- for loghost in loghost_list %}
rsyslog-config_d-{{ loghost }}:
  file.touch:
    - name: /etc/rsyslog.d/{{ loghost }}.conf
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}
{%- endfor %}
