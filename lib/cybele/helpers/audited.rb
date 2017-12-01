# frozen_string_literal: true

module Cybele
  module Helpers
    module Audited
      def configure_audited
        # Generate Audited
        generate 'audited:install'
      end
    end
  end
end
