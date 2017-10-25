# Cybele

[![Gem Version](https://badge.fury.io/rb/cybele.png)](http://badge.fury.io/rb/cybele)
[![Code Climate](https://codeclimate.com/github/kebab-project/cybele.png)](https://codeclimate.com/github/kebab-project/cybele)
[![Dependency Status](https://gemnasium.com/kebab-project/cybele.png)](https://gemnasium.com/kebab-project/cybele)

**Cybele** pron.: /ˈsɪbɨliː/ was an originally Anatolian mother goddess. Little is known of her oldest Anatolian cults,
other than her association with mountains, hawks and lions. She may have been Phrygia's State deity; her Phrygian cult
was adopted and adapted by Greek colonists of Asia Minor, and spread from there to mainland Greece and its more distant
western colonies from around the 6th century BCE.

## Requirements

Before generating your application, you will need:

* Ruby ~> 2.3
* Rails ~> 4.2

## Usage

First you should install the cybele gem than you can use it for creating new gem.

    ```ruby
        gem install cybele
        cybele project_name
    ```

When the initialization is completed, there will be some required settings.

* Set .env.local variables
* Set ENV['ROLLBAR_ACCESS_TOKEN'] for Rollbar.
* If Sidekiq will be use, you must open sidekiq option in config/initializers/rollbar.rb like the following:
    ```ruby 
        config.use_sidekiq 'queue' => 'default' 
    ```
* If you don't want to use Rollbar in development environment, you can disable for development environment in 
  in config/initializers/rollbar.rb
* If you want to sign up email notification in staging environment, you can add mails like the following: 
    ```ruby 
        [Settings.email.sandbox, 'user1@example.com', 'user2@example.com']
    ``` 
* Set default values for is_active, time_zone variable using in User and Admin model migrations db/migrate/*.rb
* Change username and password in config/settings.yml
* In public folder run this command ln -s ../VERSION.txt VERSION.txt

We are using sidekiq  with redis-server for background jobs.
Before the run application look our env.sample file. It should be in project root directory with this name .env.local
```bash
bundle
redis-server
rake sidekiq:start
rake db:create
rake db:migrate
rake dev:seed
rails s
```

## What cybele do and included?

Let's look the [Gemfile](https://raw.github.com/lab2023/cybele/develop/templates/cybele_Gemfile) which created by cybele.

## Bugs and  Feedback

If you discover any bugs or want to drop a line, feel free to create an issue on GitHub.

http://github.com/lab2023/cybele/issues

## Contributing

Cybele uses [rDoc](http://rubydoc.info/gems/cybele) and [SemVer](http://semver.org/), and takes it seriously.

Once you've made your great commits:

1. Fork Template
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create a Pull Request from your branch
5. That's it!

## Credits

![lab2023](http://lab2023.com/assets/images/named-logo.png)

- Cybele is maintained and funded by [lab2023 - information technologies](http://lab2023.com/)
- Thank you to all the [contributors!](../../graphs/contributors)
- This gem is inspired from [suspender](https://github.com/thoughtbot/suspenders)
- The names and logos for lab2023 are trademarks of lab2023, inc.

## License

Copyright © 2013-2015 [lab2023 - information technologies](http://lab2023.com)