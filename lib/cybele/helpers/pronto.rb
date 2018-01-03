# frozen_string_literal: true

module Cybele
  module Helpers
    module Pronto
      def configure_pronto
        # Create pronto files
        template 'pronto/example.pronto.yml.erb',
                 'example.pronto.yml',
                 force: true
        template 'pronto/example.pronto.yml.erb',
                 '.pronto.yml',
                 force: true
        template 'pronto/.haml-lint.yml.erb',
                 '.haml-lint.yml',
                 force: true
        template 'pronto/config.reek.erb',
                 'config.reek',
                 force: true
        template 'pronto/.rubocop.yml.erb',
                 '.rubocop.yml',
                 force: true
        template 'pronto/rubo.erb',
                 'bin/rubo',
                 force: true
        run 'chmod +x bin/rubo'

        # Ignore secret information file
        append_file('.gitignore', '.pronto.yml')
      end
    end
  end
end
