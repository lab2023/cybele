# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module VendorFiles
        def customize_vendor_files
          # View files with option
          directory 'app_files/app/vendor', 'app/vendor'
        end
      end
    end
  end
end
