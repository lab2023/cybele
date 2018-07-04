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

* Ruby ~> 2.5.1
* Rails ~> 5.2.0

## Usage

First you should install the cybele gem than you can use it for creating new gem.

```ruby
gem install cybele
cybele project_name
```
 

When the initialization is completed, there will be some required settings.

* Set .env.local variables
* If you don't want to use Rollbar in development environment, you can disable for development environment in config/initializers/rollbar.rb
* Change username and passwords in config/settings.yml

## What cybele do and included?

Let's look options

```ruby
cybele --help
```

## Bugs and  Feedback

If you discover any bugs or want to drop a line, feel free to create an issue on GitHub.

http://github.com/lab2023/cybele/issues

## Development
* Clone project
* Run: brew install cmake
* Run: bundle

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

Copyright © 2013-2018 [lab2023 - information technologies](http://lab2023.com)
