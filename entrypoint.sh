#!/bin/bash

# Esperar o banco de dados estar pronto (opcional)
# Você pode usar um script como wait-for-it ou adicionar um loop de espera

# Executar builds, migrações e otimizações
composer install --no-dev --optimize-autoloader
npm install

npm run build

php artisan migrate

php artisan optimize:clear
php artisan optimize

# Iniciar o servidor Octane com FrankenPHP primeiro
exec php artisan octane:frankenphp &

# Esperar um tempo para o Octane inicializar (se necessário, ajuste o tempo)
sleep 5

# Iniciar o Supervisor
if ! pgrep supervisord > /dev/null; then
    supervisord
fi
supervisorctl reread
supervisorctl update
supervisorctl start "laravel-worker:*"
