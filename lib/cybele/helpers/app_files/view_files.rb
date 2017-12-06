# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ViewFiles
        def customize_view_files_with_option
          # View files with option
          directory 'app_files/app/views/hq', 'app/views/hq'
          directory 'app_files/app/views/user', 'app/views/user'
          directory 'app_files/app/views/layouts/hq', 'app/views/layouts/hq'
          directory 'app_files/app/views/layouts/partials', 'app/views/layouts/partials'
          directory 'app_files/app/views/welcome', 'app/views/welcome'
          replace_erb_with_haml
        end

        def customize_default_view_files
          # Default view files
          directory 'app_files/app/views/admin_mailer', 'app/views/admin_mailer'
          directory 'app_files/app/views/user_mailer', 'app/views/user_mailer'
        end

        def replace_erb_with_haml
          remove_file 'app/views/welcome/index.html.erb', force: true
          template 'app_files/app/views/welcome/index.html.erb',
                   'app/views/welcome/index.html.haml', force: true

          remove_file 'app/views/layouts/mailer.html.erb', force: true
          template 'app_files/app/views/layouts/mailer.html.erb',
                   'app/views/layouts/mailer.html.haml', force: true

          remove_file 'app/views/layouts/application.html.erb', force: true
          template 'app_files/app/views/layouts/application.html.erb',
                   'app/views/layouts/application.html.haml', force: true

          remove_file 'app/views/layouts/partials/_navbar.html.erb', force: true
          template 'app_files/app/views/layouts/partials/_navbar.html.erb',
                   'app/views/layouts/partials/_navbar.html.haml', force: true

          remove_file 'app/views/layouts/hq/application.html.erb', force: true
          template 'app_files/app/views/layouts/hq/application.html.erb',
                   'app/views/layouts/hq/application.html.haml', force: true
        end
      end
    end
  end
end
