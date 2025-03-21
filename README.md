# PHP Docker Dev

This repo contains the *docker compose* configuration to set up various Docker containers for PHP development. 



## Warning

This package was developed for my own **personal use**. It might not suit your needs or be documented properly, and may change at any time.



### Mac Users - Warning

***NOTE:*** This package was written for use in Ubuntu, and has not been tested on a Mac.

Macs have an older version of *bash* that will stop the `./doc` shell script from working (associative arrays were first introduced in bash 4).

Mac users may need to turn the `.env` `SET_WWW_DATA_USER` option off.



## Installation

1. Clone the repository: `git clone https://github.com/code-distortion/php-docker-dev.git .`
2. Create a `.env` file by making a copy of `.env.example`, and update it with the settings you need.
3. Build the containers using the `./doc` *docker compose* wrapper: `./doc up -d --build`



## Usage - The *docker compose* Wrapper: `./doc`

The `./doc` bash script is a ***docker compose*** wrapper.

It chooses which *compose/xxx.yml* files to use, as well as provide shortcuts for common *docker compose* commands.

Use this to interact with the containers instead of using *docker compose* directly.



### compose/xxx.yml files

`./doc` first looks for the available `compose/*.yml` files. Each file represents one container:

```
mailpit.yml
mariadb.yml 
mysql.yml
mysql-memory.yml
nginx.yml
node.yml
ollama.yml
php.yml
postgres.yml
redis.yml
selenium-chrome.yml
```

It then checks with `.env` to see which ones are enabled - via corresponding `xxx_CONTAINER=true` values:

```
MAILPIT_CONTAINER=false
MARIADB_CONTAINER=false
MYSQL_CONTAINER=false
MYSQL_MEMORY_CONTAINER=false
NGINX_CONTAINER=false
NODE_CONTAINER=false
OLLAMA_CONTAINER=false
PHP_CONTAINER=true
PHP_OLD_CONTAINER=false
POSTGRES_CONTAINER=false
PYTHON_CONTAINER=false
REDIS_CONTAINER=false
SELENIUM_CHROME_CONTAINER=false
```

> Extra containers can be added by adding a `compose/xxx.yml` file and a corresponding `xxx_CONTAINER=true` value to the `.env` file. They will be picked up automatically when using `./doc`.

It then passes execution to *docker compose*, passing the enabled .yml configuration files:

``` bash
# this command
./doc ps
# will run
docker compose --project-directory=. -f compose/php.yml ps
# (if the PHP container is the one that's enabled)
```



### Interacting With Containers

- All regular *docker compose* commands are passed through to *docker compose*. e.g.
  - Build the containers: `./doc up -d --build`
  - Stop containers: `./doc stop`
  - Show container status: `./doc ps`
  - etc.
- Bash into a container by passing the container name. e.g.
  - `./doc php`
  - `./doc mysql`
- Bash into a container as *root* by passing the container name. e.g.
  - `./doc sudo php`
- Enter into the database mysql client (only when the MySQL container is being used).
  - `./doc db`
- Run a command in a container. e.g.
  - `./doc php whoami`
- Run a command in a container as *root*. e.g.
  - `./doc sudo php whoami`



## Available Containers

You can change the image used for any container by updating your `.env` file.



### The PHP Container

Choose the PHP version and pick other settings in the `.env` file.



#### The *www-data* User's UID and GID 

You have the option of setting the *www-data* user's *uid* and *gid* in the PHP container.

`./doc` picks the ***current host user's*** uid and gid by default, although you can hard-code them via `WWW_DATA_UID` and `WWW_DATA_GID` in the `.env` file.

This allows for the www-data user in the container to have the same access to files as your host user.

**This is applied at build-time**, and is enabled by default. You can turn it off by setting `SET_WWW_DATA_USER=false` in the `.env` file.



#### Quick Access to the Database

When inside the PHP container, you can open the MySQL client and connect straight to the database by running `db` (only when the MySQL container is being used).



### The MailPit Container

Uses the `axllent/mailpit:latest` image.



### The MariaDB Container

Uses the `mariadb:11.6.2` image.



### The MySQL Container

Uses the `mysql:8.4` image.



### The MySQL-memory Container

Uses the `mysql:8.4`image.

Runs the container with the `/var/lib/mysql` as a *tmpfs* volume, which means the data is stored in memory and is lost when the container is stopped. Which is useful for running tests.



### The Nginx Container

Uses the `nginx:1-alpine-slim` image.



### The Node Container

Uses the `node:23-bookworm` image.



### The Ollama Container

Uses the `ollama/ollama:latest` image.



### The PHP Container

Uses the `php:8.4.1-fpm-bookworm` image.



### The PostgreSQL Container

Uses the `postgres:17-alpine` image.



### The Python Container

Uses the `python:latest` image.



### The Redis Container

Uses the `redis:alpine` image.



### The Selenium Container

Uses the `selenium/standalone-chrome:latest` image.



## Credits

- [Tim Chandler](https://github.com/code-distortion)



## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
