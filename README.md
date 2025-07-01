# Start with

Maybe you need remove the credentials in first moment and create the secret_key_base:

```bash
rm config/credentials.yml.enc config/master.key
EDITOR="code --wait" rails credentials:edit
```

```yaml
development:
  secret_key_base: your_long_random_string_here
```

And copy the output generate by

```bash
rails secret
```

paste in .env file with

```.env
SECRET_KEY_BASE=
```

## With Docker

Need To Clean All Your Docker?

```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker system prune -a --volumes -f
docker network rm $(docker network ls -q)
rm .db-created
rm .db-seeded
chmod 777 Gemfile.lock
```

## Putting In Development Mode

Whereas It Is Necessary To Run With Your User, Run

```bash
id -u
```

And Change The Dockerfile.Development File With The Value You Found

So Build You Just Need To Run The First Time:

```bash
docker compose -f docker-compose.development.yml build
```

And To Climb The Application Rode:

```bash
FORCE_DB_CREATE=true FORCE_DB_SEED=true docker compose -f docker-compose.development.yml down
FORCE_DB_CREATE=true FORCE_DB_SEED=true docker compose -f docker-compose.development.yml up --build
FORCE_DB_CREATE=true FORCE_DB_SEED=true docker compose -f docker-compose.development.yml up
docker compose -f docker-compose.development.yml down -v
docker compose -f docker-compose.development.yml run app bundle install
docker compose -f docker-compose.development.yml run app bash
docker compose -f docker-compose.development.yml run app rails routes
docker compose -f docker-compose.development.yml run app rails c
docker compose -f docker-compose.development.yml run app rails g sidekiq:job PayShoppingCart
```

## Testing with Docker

For Tests For Example Run `Guard`:

```bash
docker compose -f docker-compose.development.yml run -e RAILS_ENV=test app bundle exec guard
```

For Migrations (Remembering That You May Need To Run Both In Development And Test):

```bash
docker compose -f docker-compose.development.yml run app rails db:migrate
docker compose -f docker-compose.development.yml run app rails db:seed
```

and after

```bash
bin/jobs start
```