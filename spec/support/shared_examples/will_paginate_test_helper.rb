# frozen_string_literal: true

shared_examples 'uses will_paginate' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'will_paginate'/)
      expect(gemfile_file).to match(/^gem 'will_paginate-bootstrap'/)
    end
  end
end
