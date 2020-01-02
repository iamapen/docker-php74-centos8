FROM centos:centos8
MAINTAINER iamapen

# mod_php, その他
RUN set -x \
  && dnf install -y epel-release \
  && dnf install -y yum-utils \
  && echo 'fastestmirror=true' >> /etc/dnf/dnf.conf \
  && rpm --import https://rpms.remirepo.net/RPM-GPG-KEY-remi \
  && dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm \
  && dnf module reset php \
  && dnf module install -y php:remi-7.4 \
  && dnf install -y --enablerepo=remi php php-cli php-bcmath php-gd php-gmp \
       php-json php-mbstring php-mysqlnd php-pdo php-pecl-mysql php-xml php-intl php-pecl-xdebug php-zip \
       php-pecl-swoole4 \
       mod_ssl \
  && dnf install -y git \
  && curl -s -o /usr/local/bin/composer https://getcomposer.org/download/1.9.1/composer.phar \
  && chmod 755 /usr/local/bin/composer \
  && /usr/local/bin/composer global require hirak/prestissimo \
  && dnf install -y rsync openssh-clients \
  && dnf clean all

# 自己証明書を発行
RUN set -x \
  && cd /tmp \
  && openssl genrsa 2048 > server.key \
  && openssl req -new -key server.key -subj "/C=JP/ST=Tokyo/L=Chuo-ku/O=iamapen/OU=web/CN=localhost" > server.csr \
  && openssl x509 -in server.csr -days 3650 -req -signkey server.key > server.crt \
  && chmod 400 server.key \
  && mv server.key /etc/pki/tls/private/localhost.key \
  && mv server.crt /etc/pki/tls/certs/localhost.crt \
  && chmod 755 -R /var/www/html

# 設定ファイル
COPY docker/etc/httpd/ /etc/httpd/
COPY docker/etc/php.ini /etc/
COPY docker/etc/php.d/ /etc/php.d/
COPY docker/etc/php-zts.d/ /etc/php-zts.d/
COPY docker/etc/php-fpm.conf /etc/
COPY docker/etc/php-fpm.d/ /etc/php-fpm.d/

EXPOSE 80
EXPOSE 443

CMD ["httpd", "-D", "FOREGROUND"]

