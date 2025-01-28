FROM php:8.1-apache-bookworm

# Install dependencies and clean up
RUN apt-get update && apt-get install -y \
    zip unzip git gettext curl gsfonts software-properties-common libmagickwand-dev --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setting up source code
RUN git clone https://github.com/monarc-project/MonarcAppFO.git /var/lib/monarc/fo
WORKDIR /var/lib/monarc/fo
RUN mkdir -p data/cache data/LazyServices/Proxy data/DoctrineORMModule/Proxy

# Install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    rm composer-setup.php

# Install PHP extensions
RUN pecl install imagick apcu 
RUN docker-php-ext-enable imagick apcu
RUN docker-php-ext-install bcmath intl gd pdo_mysql xml

# Install node.js, npm, and grunt-cli
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 14.19.3 && \
    npm install -g grunt-cli

# Install dependencies for Monarc
RUN composer install -o --no-dev --no-cache --ignore-platform-req=php
RUN chown -R www-data:www-data data/
RUN chmod -R 755 data/

# Configure Apache
RUN a2dismod status && a2enmod ssl && a2enmod rewrite && a2enmod headers
RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY vhost.conf /etc/apache2/sites-available/monarc.conf
RUN ln -s /etc/apache2/sites-available/monarc.conf /etc/apache2/sites-enabled/monarc.conf

# Setting up Back-end
RUN mkdir -p module/Monarc
RUN ln -s /var/lib/monarc/fo/vendor/monarc/core ./module/Monarc/Core
RUN ln -s /var/lib/monarc/fo/vendor/monarc/frontoffice ./module/Monarc/FrontOffice

# Setting up Front-end
RUN mkdir node_modules
RUN git clone https://github.com/monarc-project/ng-client.git node_modules/ng_client --branch v2.12.7
RUN git clone https://github.com/monarc-project/ng-anr.git node_modules/ng_anr --branch v2.12.7

# Setting up db connection
COPY local.php ./config/autoload/local.php

# Expose Apache
EXPOSE 80

# CMD to run the app
CMD ["sh", "-c", "/var/lib/monarc/fo/scripts/update-all.sh -c; apache2-foreground"]
