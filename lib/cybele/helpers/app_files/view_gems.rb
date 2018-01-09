# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module ViewGems
        def add_required_view_gems
          files = %w[
            app_files/bootstrap_Gemfile.erb
            app_files/breadcrumb_Gemfile.erb
            app_files/jquery_Gemfile.erb
          ]
          files.each do |file|
            append_template_to_file('Gemfile', file)
          end
        end
      end
    end
  end
end
