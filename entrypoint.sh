#!/bin/bash

# Esperar o banco de dados estar pronto (opcional)
# Você pode usar um script como wait-for-it ou adicionar um loop de espera

# Executar builds, migrações e otimizações
composer install --no-dev --optimize-autoloader
npm install

npm run build

php artisan migrate --force

php artisan optimize:clear
php artisan optimize

# Iniciar o cron
cron

# Iniciar o Supervisor
if ! supervisorctl status > /dev/null 2>&1; then
    supervisord -c /etc/supervisor/supervisord.conf
fi

supervisorctl reread
supervisorctl update
supervisorctl start "laravel-worker:*"

# Iniciar o Octane como o último processo
exec php artisan octane:frankenphp
