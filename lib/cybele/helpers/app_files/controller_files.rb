# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ControllerFiles
        def customize_controller_files
          # Controller concern files
          directory 'app_files/app/controllers/concerns', 'app/controllers/concerns'

          # Hq controller files
          directory 'app_files/app/controllers/hq', 'app/controllers/hq'

          # User controller files
          directory 'app_files/app/controllers/user', 'app/controllers/user'

          # Welcome controller
          copy_file 'app_files/app/controllers/welcome_controller.rb', 'app/controllers/welcome_controller.rb'
        end
      end
    end
  end
end
