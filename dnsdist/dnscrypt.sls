{% from "dnsdist/map.jinja" import dnsdist with context %}

libnacl:
  pip.installed:
    - require:
      - pkg: dnsdist

dnsdist_console_config:
  file.managed:
    - name: /etc/dnsdist/console.conf
    - source: salt://dnsdist/files/console.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: dnsdist
    - watch_in:
      - service: dnsdist

#temporarily disable private temp:
#  file.replace:
#    - name: /etc/systemd/system/multi-user.target.wants/dnsdist.service
#    - pattern: 'PrivateTemp=true'
#    - repl: 'PrviateTemp=false'
#    - backup: True
#
#systemctl daemon-reload:
#  cmd.run

script for cert creation:
  file.managed:
    - name: /etc/dnsdist/dnscrypt.conf
    - source: salt://dnsdist/files/dnscrypt.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: dnsdist

run command:
 cmd.run:
    - name: cat /etc/dnsdist/dnscrypt.conf | dnsdist -c


{% for k in ['provider_private_key',  'provider_public_key', 'resolver_cert', 'resolver_key'] %}
{% set file_name = dnsdist.dnscrypt.get(k) %}
{% set location = salt['file.find']('/tmp', type='f', name=file_name) %}
{% for i in location %}
copy {{ file_name }}:
  file.copy:
    - name: /etc/dnsdist/{{ file_name }}
    - source: {{ i }}
{% endfor %}
{% endfor %}
#move the keys:
#  cmd.run:
#    - name: find /tmp/ -path ./systemd-private*dnsdist*/ -o -iname *.key -exec cp {} /etc/dnsdist/ \;

#move the certs:
#  cmd.run:
#    - name: find /tmp/ -path ./systemd-private*dnsdist*/ -o -iname *.cert -exec cp {} /etc/dnsdist/ \;



#{% for k, v in dnsdist.dnscrypt.items() %}
#{% if k.startswith('provider') or k.startswith('resolver') %}
#move {{ v }}:
#  file.copy:
#    - name: /etc/dnsdist/{{ v }}
#    - source: /tmp/{{ v }}
#    - mode: 600
#    - root: root
#    - group: root
#{% endif %}
#{% endfor %}
