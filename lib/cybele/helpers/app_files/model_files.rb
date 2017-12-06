# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ModelFiles
        def customize_model_files
          # Model files
          remove_file 'app/models/admin.rb', force: true
          remove_file 'app/models/user.rb', force: true
          directory 'app_files/app/models', 'app/models'
        end
      end
    end
  end
end
