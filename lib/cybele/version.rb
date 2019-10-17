# frozen_string_literal: true

module Cybele
  RAILS_VERSION = '~> 6.0'.freeze
  RUBY_VERSION = IO.read("#{File.dirname(__FILE__)}/../../.ruby-version").strip
  VERSION = '2.3.2'
end
