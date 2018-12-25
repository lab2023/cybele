# frozen_string_literal: true

module Cybele
  module Helpers
    module Pronto
      def configure_pronto
        # Create pronto files
        create_config_files
        template 'pronto/rubo.erb',
                 'bin/rubo',
                 force: true
        run 'chmod +x bin/rubo'

        # Ignore secret information file
        append_file('.gitignore', '.pronto.yml')
      end

      private

      def create_config_files
        template 'pronto/example.pronto.yml.erb',
                 '.pronto.yml',
                 force: true
        files_to_template(
          'pronto/example.pronto.yml.erb' => 'example.pronto.yml',
          'pronto/.haml-lint.yml.erb' => '.haml-lint.yml',
          'pronto/.erb-lint.yml.erb' => '.erb-lint.yml',
          'pronto/.rubocop.yml.erb' => '.rubocop.yml',
          'pronto/.flayignore.erb' => '.flayignore'
        )
      end
    end
  end
end
