FROM ubuntu:22.04
MAINTAINER Hippolyte MOFFO(hippo2451@yahoo.com)
WORKDIR  /tmp/
EXPOSE 8080
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget apache2 php8.1 php8.1-curl php8.1-zip php8.1-gd php8.1-intl php8.1-intl php-pear php8.1-imagick php8.1-imap php-memcache php8.1-pspell php8.1-tidy php8.1-xmlrpc php8.1-xsl php8.1-mbstring php8.1-ldap php8.1-ldap php-cas php-apcu libapache2-mod-php8.1 php8.1-mysql php-bz2
RUN rm -Rf /var/www/html/*
RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.2/glpi-10.0.2.tgz
RUN tar -xvf glpi-10.0.2.tgz
RUN rm -Rf glpi-10.0.2.tgz
RUN cp -r glpi/* /var/www/html/
RUN useradd --uid 10000 user
RUN chmod 755 -R /var/www/html/
RUN chown user:user -R /var/www/html/
RUN chown user:user -R /usr/sbin/apache2ctl
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
USER user
