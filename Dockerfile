# Base OS
FROM debian:buster

# ENV
ENV AUTOINDEX="on"

# COPY
COPY srcs/ /root/

# Install packages
RUN apt-get update && apt-get install -y nginx mariadb-server php7.3-fpm php7.3-mysql php7.3-mbstring php7.3-zip php7.3-gd  wget

# Configure Mariadb
RUN bash /root/mysql.sh

# phpMyAdmin
# Download
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
RUN tar xvf phpMyAdmin-4.9.5-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.5-all-languages/ phpmyadmin/
RUN mv phpmyadmin/ /var/www/html/
RUN rm phpMyAdmin-4.9.5-all-languages.tar.gz
# Configuration
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN rm /var/www/html/phpmyadmin/config.sample.inc.php
RUN cp /root/config.inc.php /var/www/html/phpmyadmin/
RUN chown -R www-data:www-data /var/lib/phpmyadmin
RUN bash root/phpmyadmin.sh

# Wordpress
# Download
RUN wget https://wordpress.org/latest.tar.gz
RUN tar xvf latest.tar.gz
RUN mv wordpress /var/www/html
RUN rm latest.tar.gz
# Configuration
RUN cp /root/wp-config.php /var/www/html/wordpress/
RUN rm /var/www/html/wordpress/wp-config-sample.php
RUN chown -R www-data:www-data /var/www/html/wordpress/

# Set SSL certificate
RUN openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=hyuki/CN=localhost" -out /etc/ssl/certs/localhost.crt -keyout /etc/ssl/private/localhost.key

# Move Autoindextest
RUN cp -r /root/test_autoindex/ /var/www/html/

# Launch all
CMD bash /root/set_nginx.sh && service nginx start && service mysql restart && service php7.3-fpm start && tail -f /dev/null
