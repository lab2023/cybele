# frozen_string_literal: true

module Cybele
  module Helpers
    module AppFiles
      module MailerFiles
        def customize_mailer_files
          # Model files
          remove_file 'app/mailers/application_mailer.rb', force: true
          directory 'app_files/app/mailers', 'app/mailers'
        end
      end
    end
  end
end
