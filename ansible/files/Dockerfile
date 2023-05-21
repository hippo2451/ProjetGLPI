FROM ubuntu:22.04
MAINTAINER Hippolyte MOFFO(hippo2451@yahoo.com)
WORKDIR  /tmp/


EXPOSE 8080
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget apache2 php8.1 php8.1-curl php8.1-zip php8.1-gd php8.1-intl php8.1-intl php-pear php8.1-imagick php8.1-imap php-memcache php8.1-pspell php8.1-tidy php8.1-xmlrpc php8.1-xsl php8.1-mbstring php8.1-ldap php8.1-ldap php-cas php-apcu libapache2-mod-php8.1 php8.1-mysql php-bz2 && \
    rm -Rf /var/www/html/* && \
    wget https://github.com/glpi-project/glpi/releases/download/10.0.2/glpi-10.0.2.tgz && \
    tar -xvf glpi-10.0.2.tgz && \
    rm -Rf glpi-10.0.2.tgz && \
    cp -r glpi/* /var/www/html/ && \
    useradd --uid 10000 glpi && \
    chmod 755 -R /var/www/html/ && \
    chown glpi:glpi -R /var/www/html/ && \   
    chown www-data:www-data -R /var/www/html/ && \
    chown glpi:glpi -R /var/log/apache2/ && \
    chown glpi:glpi -R  /var/run/apache2 && \
    sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf && \
    sed -i "s/80/8080/" /etc/apache2/sites-enabled/000-default.conf 
USER glpi
COPY glpi-scripts /usr/src/glpi-scripts
ENTRYPOINT ["sh", "/usr/src/glpi-scripts/entrypoint.sh"]
