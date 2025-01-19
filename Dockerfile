FROM dunglas/frankenphp
 
RUN apt-get update && apt-get install -y \
    supervisor \
    cron \
    libzip-dev \
    unzip \
    && install-php-extensions \
    pcntl \
    pdo_pgsql \
    pdo_mysql \
    opcache \
    intl \
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
 
COPY . /app

WORKDIR /app

# Copiar arquivo de configuração para o supervisor
COPY ./laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf

# Criar diretório para logs do supervisor que foi definido no laravel-worker.conf
RUN mkdir -p /app/supervisor

# Adicionar configuração do cron
RUN echo "* * * * * cd /app && php artisan schedule:run >> /dev/null 2>&1" > /etc/cron.d/laravel-scheduler
RUN chmod 0644 /etc/cron.d/laravel-scheduler
RUN crontab /etc/cron.d/laravel-scheduler
RUN touch /var/log/cron.log

# Instalando o composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalando o NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Definindo permissões
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache
RUN chmod -R 775 /app/storage /app/bootstrap/cache
