# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ViewGems
        def add_required_view_gems
          # Add bootstrap gem
          append_file('Gemfile', template_content('app_files/bootstrap_Gemfile.erb'))

          # Add blankable gem
          append_file('Gemfile', template_content('app_files/blankable_Gemfile.erb'))

          # Add breadcrumb gem
          append_file('Gemfile', template_content('app_files/breadcrumb_Gemfile.erb'))

          # Add fontawesome gem
          append_file('Gemfile', template_content('app_files/fontawesome_Gemfile.erb'))
        end
      end
    end
  end
end
