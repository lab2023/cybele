# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ViewFiles
        def customize_view_files_with_option
          # View files with option
          dirs_to_directory(
            'app_files/app/views/hq' => 'app/views/hq',
            'app_files/app/views/user' => 'app/views/user',
            'app_files/app/views/layouts/hq' => 'app/views/layouts/hq',
            'app_files/app/views/layouts/partials' => 'app/views/layouts/partials',
            'app_files/app/views/welcome' => 'app/views/welcome',
            'app_files/public' => 'public'
          )
          replace_erb_with_haml
        end

        def customize_default_view_files
          # Default view files
          dirs_to_directory(
            'app_files/app/views/admin_mailer' => 'app/views/admin_mailer',
            'app_files/app/views/user_mailer' => 'app/views/user_mailer'
          )
        end

        private

        def remove_erb_files(template_files)
          remove_file 'app/views/layouts/mailer.html.erb',
                      force: true
          remove_files(template_files)
        end

        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/LineLength
        def replace_erb_with_haml
          template_files = %w[
            app/views/welcome/index.html.haml.erb
            app/views/layouts/mailer.html.haml.erb
            app/views/layouts/application.html.haml.erb
            app/views/layouts/partials/_navbar.html.haml.erb
            app/views/layouts/hq/application.html.haml.erb
            app/views/layouts/hq/login.html.haml.erb
          ]
          remove_erb_files(template_files)
          files_to_template(
            'app_files/app/views/welcome/index.html.haml.erb' => 'app/views/welcome/index.html.haml',
            'app_files/app/views/layouts/mailer.html.haml.erb' => 'app/views/layouts/mailer.html.haml',
            'app_files/app/views/layouts/application.html.haml.erb' => 'app/views/layouts/application.html.haml',
            'app_files/app/views/layouts/partials/_navbar.html.haml.erb' => 'app/views/layouts/partials/_navbar.html.haml',
            'app_files/app/views/layouts/hq/application.html.haml.erb' => 'app/views/layouts/hq/application.html.haml',
            'app_files/app/views/layouts/hq/login.html.haml.erb' => 'app/views/layouts/hq/login.html.haml'
          )
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end
