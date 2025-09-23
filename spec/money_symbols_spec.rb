# frozen_string_literal: true

require 'money'

RSpec.describe Money do
  it 'stringifies with USD symbol' do
    expect(described_class.new(100, currency: 'USD').to_s).to eq('$1.00')
  end

  it 'stringifies with generic prefix for unknown currency' do
    expect(described_class.new(100, currency: 'XYZ').to_s).to eq('XYZ 1.00')
  end
end
