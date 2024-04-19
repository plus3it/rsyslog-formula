# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as rsyslog with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set loghost_dict = salt.pillar.get('rsyslog:lookup:remote_hosts', {}) %}

include:
  - {{ sls_package_install }}

{%- for loghost, values in loghost_dict.items() %}
file-{{ loghost }}:
  file.managed:
    - name: '/etc/rsyslog.d/{{ loghost }}.conf'
    - contents: |-
  {%- if values.protocol == 'udp' %}
        *.* @{{ loghost }}
  {%- elif values.protocol == 'tcp' %}
        *.* @@{{ loghost }}
  {%- else %}
        ## *.* {{ values.protocol }} {{ loghost }}
  {%- endif %}
{%- endfor %}
