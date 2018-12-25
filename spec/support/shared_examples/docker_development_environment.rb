# frozen_string_literal: true

shared_examples 'uses docker development environment' do
  it do
    file_exist_test(
      %w[
        docker-compose.yml
        Dockerfile
        bin/start-app.sh
        bin/start-sidekiq.sh
      ]
    )

    file_exist_test(
      %w[
        .env.sample
        .env.local
        .environments/.env.local
      ]
    ) do |env|
      file = content(env)
      expect(file).to match('REDIS_URL=redis://redis:6379/0')
      expect(file).to match('RACK_ENV=development')
      expect(file).to match('POSTGRESQL_HOST=postgres')
      expect(file).to match('REDIS_HOST=redis')
    end

    file_exist_test(
      %w[
        .environments/.env.staging
        .environments/.env.production
      ]
    ) do |env|
      expect(content(env)).to match('REDIS_URL=')
    end
  end
end

shared_examples 'uses docker development environment without sidekiq' do
  it do
    file_exist_test(
      %w[
        docker-compose.yml
        Dockerfile
        bin/start-app.sh
      ]
    )

    file_not_exist_test(%w[bin/start-sidekiq.sh])

    file_exist_test(
      %w[
        .env.sample
        .env.local
        .environments/.env.local
      ]
    ) do |env|
      file = content(env)
      expect(file).not_to match('REDIS_URL=redis://redis:6379/0')
      expect(file).to match('RACK_ENV=development')
      expect(file).to match('POSTGRESQL_HOST=postgres')
      expect(file).not_to match('REDIS_HOST=redis')
    end

    file_exist_test(
      %w[
        .environments/.env.staging
        .environments/.env.production
      ]
    ) do |env|
      expect(content(env)).not_to match('REDIS_URL=')
    end
  end
end
