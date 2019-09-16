{% from "snmp/map.jinja" import snmp with context %}

snmp:
  pkg.installed:
    - name: {{ snmp.pkg }}
  service.running:
    - name: {{ snmp.service }}
    - enable: true
    - require:
      - pkg: {{ snmp.pkg }}
{% if grains['os_family'] == 'FreeBSD' -%}
snmp:
  sysrc.managed:
    - name: snmpd_enable
    - value: YES
{% endif -%}

{% if grains['os_family'] == 'Debian' and grains['osmajorrelease'] < 9 %}
include:
  - snmp.default
{% endif %}

{% if grains['os_family'] == 'FreeBSD' %}
snmp_conf_dir:
  file.directory:
    - name: '{{ snmp.confdir }}'
    - user: root
    - group: wheel
    - mode: 0750
    - makedirs: True
{% endif %}
