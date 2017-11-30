# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ControllerFiles
        def customize_controller_files
          # HQ controller files
          directory 'app_files/app/controllers/hq', 'app/controllers/hq'
        end
      end
    end
  end
end
