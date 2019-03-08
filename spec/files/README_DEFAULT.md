# Dummy_app

# TODOs
- Change email sender domain address and basic_auth info in `config/settings.yml`
- Change email sender domain address in `config/initializers/devise.rb`
- Create `.pronto.yml` file from `example.pronto.yml` file
- Run command for create environments ➜ ✗  `rails g environment`

# Infos
- Edit secret keys
➜ ✗ EDITOR=vi bin/rails credentials:edit


# Docker development
- run following commands on terminal
➜ ✗ docker-compose build
➜ ✗ docker-compose run app bundle install
➜ ✗ docker-compose run app bundle exec rails db:create db:migrate db:seed
➜ ✗ docker-compose up
- open in your browser localhost:3000 or lvh.me:3000
- If you want to access rails console run this command before
➜ ✗ docker-compose run app bundle install --binstubs
➜ ✗ docker-compose run app bundle exec rails c

# Local development

- Change REDIS_URL and POSTGRESQL_HOST environment in `.env.local` file

- run following commands on terminal
➜ ✗ bundle exec rails server
- open in your browser localhost:3000 or lvh.me:3000

➜ ✗ redis-server
➜ ✗ bundle exec rake sidekiq:start

# Development
➜ ✗ pronto run
➜ ✗ pronto run -r haml
- On feature branch
➜ ✗ pronto run -c origin/develop