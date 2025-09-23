# frozen_string_literal: true

require 'kantox_checkout_app'

RSpec.describe Checkout do
  it 'is loaded via gem entrypoint' do
    expect(defined?(described_class)).to be_truthy
  end
end
