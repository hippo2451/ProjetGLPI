#!/bin/bash

/usr/sbin/apache2ctl -D FOREGROUND

php bin/console db:install --db-host=mysql --db-name=glpidb --db-user=glpidb --db-password=glpidb --quiet
