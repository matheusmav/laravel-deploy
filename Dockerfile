FROM dunglas/frankenphp
 
RUN apt-get update && apt-get install -y \
    supervisor \
    libzip-dev \
    unzip \
    && install-php-extensions \
    pcntl \
    pdo_pgsql \
    pdo_mysql \
    opcache \
    intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
 
COPY . /app

WORKDIR /app

COPY ./laravel-worker.conf /etc/supervisor/conf.d

# Instalando o composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalando o NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Definindo permissões
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache
RUN chmod -R 775 /app/storage /app/bootstrap/cache
