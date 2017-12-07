# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module AssetsFiles
        def customize_assets_files
          javascript_files
          stylesheet_files
        end

        def javascript_files
          # Javascript Assets files
          remove_file 'app/assets/javascripts/application.js', force: true

          template 'app_files/app/assets/javascripts/application.js',
                   'app/assets/javascripts/application.js',
                   force: true

          template 'app_files/app/assets/javascripts/hq/application.js',
                   'app/assets/javascripts/hq/application.js',
                   force: true
        end

        def stylesheet_files
          # Css Assets files
          remove_file 'app/assets/stylesheets/application.css', force: true

          template 'app_files/app/assets/stylesheets/application.css.sass',
                   'app/assets/stylesheets/application.css.sass',
                   force: true

          template 'app_files/app/assets/stylesheets/hq/application.css.sass',
                   'app/assets/stylesheets/hq/application.css.sass',
                   force: true

          copy_file 'app_files/app/assets/stylesheets/hq/_sidebar.css.sass',
                    'app/assets/stylesheets/hq/_sidebar.css.sass'
        end
      end
    end
  end
end
