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

{%- if loghost_dict | length = 0 %}
No Remote syslog defined:
  test.show_notification:
    - text: |
        --------------------------------------
        No Pillar information supplied for
        configuring logging to a remotei
        rsyslog server
        --------------------------------------
{%- else %}
  {%- for loghost, values in loghost_dict.items() %}
file-{{ loghost }}:
  file.managed:
    - name: '/etc/rsyslog.d/{{ loghost }}.conf'
    - contents: |-
    {%- if values.protocol == 'udp' or values.protocol == 'tcp' %}
        *.* action(type="omfwd"
              queue.type="linkedlist"
              queue.filename="{{ loghost }}"
              action.resumeRetryCount="-1"
              queue.saveOnShutdown="on"
              target="{{ loghost }}" port="{{ values.port }}" protocol="{{ values.protocol }}"
             )
    {%- else %}
        ## Requested protocol-name not supported
    {%- endif %}
  {%- endfor %}
{%- endif %}
