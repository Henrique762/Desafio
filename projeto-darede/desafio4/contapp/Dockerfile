FROM debian

RUN apt-get update && apt-get install apache2 -y

ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

ADD index.html /var/www/html/
ADD cor.css /var/www/html/cor.css

LABEL description ="Site02"

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/apachectl" ]
CMD [ "-D", "FOREGROUND" ]

