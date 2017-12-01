# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ViewFiles
        def customize_view_files_with_option
          # View files with option
          directory 'app_files/app/views/hq', 'app/views/hq'
          directory 'app_files/app/views/layouts/hq', 'app/views/layouts/hq'
          directory 'app_files/app/views/layouts/partials', 'app/views/layouts/partials'
          directory 'app_files/app/views/welcome', 'app/views/welcome'
          template 'app_files/app/views/layouts/application.html.haml.erb',
                   'app/views/layouts/application.html.haml', force: true
        end

        def customize_default_view_files
          # Default view files
          directory 'app_files/app/views/admin_mailer', 'app/views/admin_mailer'
        end
      end
    end
  end
end
