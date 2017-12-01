# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module AssetsFiles
        def customize_assets_files
          # Javascript Assets files
          remove_file 'app/assets/javascripts/application.js', force: true

          template 'app_files/app/assets/javascripts/application.js',
                   'app/assets/javascripts/application.js',
                   force: true

          template 'app_files/app/assets/javascripts/hq/application.js',
                   'app/assets/javascripts/hq/application.js',
                   force: true

          # Css Assets files
          remove_file 'app/assets/stylesheets/application.css', force: true

          template 'app_files/app/assets/stylesheets/application.css.sass',
                   'app/assets/stylesheets/application.css.sass',
                   force: true

          template 'app_files/app/assets/stylesheets/hq/application.css.sass',
                   'app/assets/stylesheets/hq/application.css.sass',
                   force: true
        end
      end
    end
  end
end
