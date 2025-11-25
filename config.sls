
# user_creation

create_librenms:
  user.present:
   - name: librenms
   - home: /opt/librenms
   - shell: {{ salt['cmd.run']('which bash') }}
   - createhome: False
   - system: True

#Download Librenms

git_librenms:
  cmd.run:
   - name: 'git clone https://github.com/librenms/librenms.git'
   - cwd: /opt/ 

# Set permissions

Change_ownership:
  file.directory:
    - name: /opt/librenms
    - user: librenms
    - group: librenms
    - recurse:
      - user
      - group 

Change_acls_dir:
  cmd.run:
    - name: 'setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/'
    
Change_acls:
  cmd.run:
    - name: 'setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/'

# Configure PHP dependencies

Get_Composer:
  cmd.run:
   - name: 'wget https://getcomposer.org/composer-stable.phar -O /usr/bin/composer'

Permission_composer:
  file.managed:
   - name: /usr/bin/composer
   - user: root
   - group: root
   - mode: '755'

run_composer:
  cmd.run:
   - name: './scripts/composer_wrapper.php install --no-dev'
   - runas: librenms
   - cwd: /opt/librenms

# Configure TimeZone for Php

Add_timezone:
  cmd.run:
    - name: 'sed -i "9i date.timezone =  Asia/Kolkata"  /etc/php.ini'

Change_timzone:
  cmd.run:
    - name: 'timedatectl set-timezone Asia/Kolkata'


# Configuration Of MariaDB

install_mariadb:
  pkg.installed:
   - name: mariadb-server

# Configuration PHP-FPM

Copy_librenms.conf:
  file.managed:
   - name: /etc/php-fpm.d/librenms.conf
   - source: /etc/php-fpm.d/www.conf
   - user: root
   - group: root
   - mode: '0644'   

# Nginx

install_nginx:
  cmd.run:
   - name: 'yum module install nginx:1.24 -y'

create_librenms.conf:
  file.managed:
   - name: /etc/nginx/conf.d/librenms.conf
   - source: salt://librenms/librenms.conf
   - user: root
   - group: root
   - mode: '0644'

# create Snmpd.conf 

create_snmpd_conf:
  file.managed:
   - name: /etc/snmp/snmpd.conf
   - source: salt://librenms/snmpd.conf
   - user: root
   - group: root
   - mode: '0644'  

# Make soft link

soft_link_lnms:
  file.symlink:
   - name: /usr/bin/lnms
   - target: /opt/librenms/lnms
   - force: true

Copy_lnms-completion:
  file.managed:
   - name: /etc/bash_completion.d/lnms-completion.bash
   - source: /opt/librenms/misc/lnms-completion.bash
   - user: root
   - group: root
   - mode: '0644'

# Configure Distro

get_distro:
  cmd.run:
   - name: 'curl -o /usr/bin/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro'

distro_permission:
  file.managed:
   - name: /usr/bin/distro
   - user: root
   - group: root
   - mode: '755'

# Shedule Cronjobs

crontab_config: 
  file.managed:
   - name: /etc/cron.d/librenms
   - source: /opt/librenms/dist/librenms.cron
   - user: root
   - group: root
   - mode: '0644'

# Enable Sheduler

Sheduler_service:
  cmd.run:
   - name: 'cp /opt/librenms/dist/librenms-scheduler.service /opt/librenms/dist/librenms-scheduler.timer /etc/systemd/system/'

# Log Rotation

log_rotation:
  file.managed:
   - name: /etc/logrotate.d/librenms
   - source: /opt/librenms/misc/librenms.logrotate
   - user: root
   - group: root
   - mode: '0644'

# Config.php 

Create_config_php:
  cmd.run: 
    - name: 'cp /opt/librenms/config.php.default /opt/librenms/config.php'

permissions:
  file.managed:
   - name: /opt/librenms/config.php
   - user: librenms
   - group: librenms
