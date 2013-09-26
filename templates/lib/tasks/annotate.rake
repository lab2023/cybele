namespace :annotate do
  desc 'Annotate your models!'
  task models: :environment do |t, args|
    exec 'annotate --exclude tests,fixtures,factories -p before'
  end
end