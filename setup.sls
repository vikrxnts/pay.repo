
# Install dnf-utils

install_dnf_utils:
  pkg.installed:
    - name: yum-utils

install_php_module:
  cmd.run:
    - name: 'yum module install php:8.2 -y'

install_basic_pkgs:
  pkg.installed:
    - pkgs:
       - bash-completion 
       - cronie 
       - fping 
       - git 
       - ImageMagick 
       - mariadb-server 
       - mtr  
       - nginx 
       - nmap 
       - rrdtool
       - unzip

install_snmp_pkgs:
  pkg.installed:
    - pkgs:
       - net-snmp 
       - net-snmp-utils

install_php_pkgs:
  pkg.installed:
    - pkgs:
       - php-common
       - php-fpm
       - php-cli 
       - php-gd 
       - php-gmp 
       - php-mbstring 
       - php-process 
       - php-snmp 
       - php-xml 
       - php-pecl-zip 
       - php-mysqlnd

install_python_pkgs:
  pkg.installed:
    - pkgs:
       - python3 
       - python3-PyMySQL 
       - python3-redis 
       - python3-memcached 
       - python3-pip 
       - python3-systemd
       - python-unversioned-command
       - python3-libs
