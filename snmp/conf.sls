{% from "snmp/map.jinja" import snmp with context %}
{% from "snmp/conf.jinja" import conf with context -%}

include:
  - snmp

{% if grains['os_family'] == 'FreeBSD' %}
snmp_conf_dir:
  file.directory:
    - name: '{{ snmp.confdir }}'
    - user: root
    - group: wheel
    - mode: 0750
    - makedirs: True
    - require:
      - pkg: {{ snmp.pkg }}
{% endif %}

snmp_conf:
  file.managed:
    - name: {{ snmp.config }}
    - template: jinja
    - context:
      config: {{ conf.get('settings', {}) | json }}
    - source: {{ snmp.source }}
    - user: root
    - group: {{ snmp.rootgroup }}
    - mode: 644
    - require:
      - file: snmp_conf_dir
    - watch_in:
      - service: {{ snmp.service }}
