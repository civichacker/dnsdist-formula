{% from "dnsdist/map.jinja" import dns with context %}

include:
  - dnsdist
{% if dnsdist.dnscrypt %}
  - dnsdist.dnscrypt

# Stop the service if it's running
# First lets setup the console (temporarily)
# dnscrypt_config:
# start the service
# send the commands to generate keys and certs
# stop service
{% endif %}


dnsdist_config:
  file.managed:
    - name: {{ dns.lookup.config_file }}
    - source: salt://dnsdist/files/dnsdist.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: dnsdist
    - watch_in:
      - service: dnsdist
