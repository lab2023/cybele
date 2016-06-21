namespace :dev do
  # Just run development env
  # This code run insert seed and agency data
  # A simple trick to over migration problem
  task setup: [:environment] do
    raise 'Nah, You are at production' if Rails.env.production?
    Rake::Task['dev:kill_postgres_connections'].execute
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['dev:initial'].execute
    Rake::Task['db:seed'].execute
  end

  desc 'seed test data'
  task seed: [:environment] do
    Rake::Task['db:seed'].execute
    Rake::Task['dev:countries'].execute
    Rake::Task['dev:cities'].execute
  end

  desc 'import countries'
  task countries: [:environment] do
    Country.destroy_all
    Country.create!(name: 'Türkiye')
  end

  desc 'import turkey cities'
  task cities: [:environment] do
    City.destroy_all
    cities        = YAML.load_file( "#{Rails.root.to_s}/lib/data/cities.yml")
    cities_array  = []
    turkey        = Country.first
    cities.each do |city|
      print '.'
      cities_array << {
        name: city['name'],
        country_id: turkey.id
      }
    end
    City.create!(cities_array)
  end

  task kill_postgres_connections: [:environment] do
    db_name = "#{File.basename(Rails.root)}_#{Rails.env}"
    sh = <<EOF
ps xa \
  | grep postgres: \
  | grep #{db_name} \
  | grep -v grep \
  | awk '{print $1}' \
  | xargs kill
EOF
    puts `#{sh}`
  end

end