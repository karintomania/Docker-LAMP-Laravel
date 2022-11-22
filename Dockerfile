FROM php:8.1-apache

# apache rewriteを有効化
RUN a2enmod rewrite
# 必要ライブラリとツール(git,nodejs)のインストール
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y update \
&& apt-get install -y libicu-dev gnupg2 unzip git nodejs

# PHPエクステンションのインストール
RUN docker-php-ext-install intl \
&& docker-php-ext-install pdo_mysql \
&& pecl install xdebug
# composerのインストール
COPY --from=composer /usr/bin/composer /usr/bin/composer

# DocumentRootを/var/www/html/publicに設定
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
