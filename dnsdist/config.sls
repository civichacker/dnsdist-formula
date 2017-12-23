{% from "dnsdist/map.jinja" import dnsdist with context %}


dnsdist_config:
  file.managed:
    - name: {{ dnsdist.lookup.config_file }}
    - source: salt://dnsdist/files/dnsdist.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: dnsdist
    - watch_in:
      - service: dnsdist
