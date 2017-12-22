{% from "dnsdist/map.jinja" import dnsdist with context %}

{% set os_family = salt['grains.get']('os_family') %}

{% if os_family in ['Debian', 'RedHat'] %}
include:
  - dnsdist.repo
{% endif %}

dnsdist:
  pkg.installed:
    - name: {{ dnsdist.lookup.pkg }}
    - refresh_db: True
    {% if os_family in ['Debian', 'RedHat'] %}
    - require:
      - sls: dnsdist.repo
    {% endif %}

  service.running:
    - name: {{ dnsdist.lookup.service }}
    - enable: True
    - require:
      - pkg: dnsdist
