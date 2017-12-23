{% from "dnsdist/map.jinja" import dnsdist with context %}

dnsdist_server_repo:
  pkgrepo.managed:
    - humanname: DNS Dist
    {% if salt['grains.get']('os_family') == 'Debian' %}
    - name: deb [arch=amd64] http://repo.powerdns.com/{{ salt['grains.get']('os').lower() }} {{ salt['grains.get']('oscodename') }}-dnsdist-{{ dnsdist.repo.release }} main
    - file: /etc/apt/sources.list.d/dnsdist.list
    - keyid: {{ dnsdist.repo.keyid }}
    - keyserver: keys.gnupg.net
    {% elif salt['grains.get']('os_family') == 'RedHat' %}
    {# TODO: add RHEL/CentOS support #}
    {% endif %}
