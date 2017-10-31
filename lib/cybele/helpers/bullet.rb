# frozen_string_literal: true

module Cybele
  module Helpers
    module Bullet
      def configure_bullet
        config = <<-RUBY
        config.after_initialize do
          Bullet.enable = true
          Bullet.alert = true
          Bullet.bullet_logger = true
          Bullet.console = true
          Bullet.rails_logger = true
          Bullet.add_footer = false
        end
        RUBY
        bundle_command 'exec rails generate bullet:install'
        configure_environment 'development', config
      end
    end
  end
end
