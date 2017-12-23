{% from "dnsdist/map.jinja" import dns with context %}


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
