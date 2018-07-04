# frozen_string_literal: true

module Cybele
  module Helpers
    module Staging
      def setup_staging_environment
        run 'cp config/environments/production.rb config/environments/staging.rb'
      end
    end
  end
end
