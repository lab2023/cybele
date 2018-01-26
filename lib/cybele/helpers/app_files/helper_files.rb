# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module HelperFiles
        def customize_helper_files
          # Helper files
          remove_file 'app/helpers/application_helper.rb', force: true
          template 'app_files/app/helpers/application_helper.rb.erb', 'app/helpers/application_helper.rb'
        end
      end
    end
  end
end
