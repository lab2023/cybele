#!/bin/bash

bundle check || bundle install
bundle config git.allow_insecure true

# Create directory if not exists
if [ ! -d ./tmp/pids ]; then
    mkdir ./tmp/pids
fi

# If file exist stop sidekiq
if [ -f ./tmp/pids/sidekiq.pid ]; then
{
    echo 'Stopping sidekiq'
    bundle exec sidekiqctl stop tmp/pids/sidekiq.pid

    echo 'Stopped sidekiq'
    rm -rf ./tmp/pids/sidekiq.pid
} || {
    echo 'Error occurred when stopping sidekiq'
}
fi

echo 'Starting sidekiq'
bundle exec sidekiq -C config/sidekiq.yml

echo 'Started sidekiq'