# Aplicações em desenvolvimento com Laravel Sail e Devcontainer

Não há necessidade de usar uma ferramenta diferente do Sail para novas aplicações. Siga os passos abaixo para instalar e configurar seu ambiente Laravel usando Sail.

## Instalação do Laravel

Execute o seguinte comando para instalar o Laravel com suporte ao MySQL e Devcontainer:

```bash
curl -s "https://laravel.build/example-app?with=mysql&devcontainer" | bash
```

**Serviços disponíveis**: `mysql`, `pgsql`, `mariadb`, `redis`, `memcached`, `meilisearch`, `typesense`, `minio`, `selenium` e `mailpit`.

> **Nota**: Se estiver usando esta aplicação em um servidor, comente as definições de portas no `docker-compose` para evitar conflitos.

## Iniciando a Aplicação

Para subir a aplicação em segundo plano, execute:

```bash
sail up -d
```
Defina as permissões na pasta `/var/www` dentro do container:

```bash
chown -R sail:sail html
```

## Utilização do Usuário Sail

Dentro do container, use o comando `su sail` para trocar para o usuário `sail`. Se preferir não entrar no container, defina um alias para o comando `sail`:

```bash
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
```


## Aplicações Existentes sem a Pasta `vendor`

Para aplicações já existentes que não possuem a pasta `vendor`, use o comando abaixo para instalar as dependências:

```bash
docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    laravelsail/php83-composer:latest \
    composer install --ignore-platform-reqs
```

Para adicionar um Devcontainer à sua aplicação já existente, execute:

```bash
php artisan sail:install --devcontainer
```