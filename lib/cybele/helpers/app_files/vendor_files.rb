# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module VendorFiles
        def customize_vendor_files
          # javascript and stylesheet files in vendor
          directory 'app_files/app/vendor/assets', 'vendor/assets'
        end
      end
    end
  end
end
