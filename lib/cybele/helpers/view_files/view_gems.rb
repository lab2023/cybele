# frozen_string_literal: true

module Cybele
  module Helpers
    module ViewFiles
      module ViewGems
        def add_required_view_gems
          # Add bootstrap gem
          append_file('Gemfile', template_content('view_files/bootstrap_Gemfile.erb'))
        end
      end
    end
  end
end
