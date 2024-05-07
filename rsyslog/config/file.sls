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

{%- if not loghost_dict %}
No Remote syslog defined:
  test.fail_without_changes:
    - comment: |
        ----------------------------------------
        No Pillar information supplied for
        configuring logging to a remote rsyslog
        server
        ----------------------------------------
{%- else %}
  {%- for loghost, values in loghost_dict.items() %}
    {%- if values.encrypted or values.relp %}
Bad sub-option:
  test.fail_without_changes:
    - comment: |
        ----------------------------------------
        {{ loghost }}:
          Neither the 'encrypted' nor the 'relp'
          sub-options are currently supported by
          this saltstack formula
        ----------------------------------------
    {%- elif values.protocol == 'udp' or values.protocol == 'tcp' %}
file-{{ loghost }}:
  file.managed:
    - name: '/etc/rsyslog.d/{{ loghost }}.conf'
    - contents: |-
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
