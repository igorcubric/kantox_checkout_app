# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/bin/'
  add_filter '/scripts/'
  add_filter '/docs/'
  add_filter '/.github/'
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# auto-load support/
Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each { |f| require f }