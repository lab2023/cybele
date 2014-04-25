namespace :dev do
  # Just run development env
  # This code run insert seed and agency data
  # A simple trick to over migration problem
  task :setup => [:environment] do
    raise 'Nah, You are at production' if Rails.env.production?
    Rake::Task['dev:kill_postgres_connections'].execute
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['dev:initial'].execute
    Rake::Task['db:seed'].execute
  end

  task :initial => [:environment] do
    User.create(email: 'user@example.com', password: '12341234', password_confirmation: '12341234')
    Admin.create(email: 'admin@example.com', password: '12341234', password_confirmation: '12341234')
  end

  task :kill_postgres_connections => [:environment] do
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