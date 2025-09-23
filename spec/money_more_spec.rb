# frozen_string_literal: true

require 'money'

RSpec.describe Money do
  it 'zero? works' do
    expect(described_class.new(0).zero?).to be true
  end

  it 'Comparable > works on same currency' do
    expect(described_class.new(100) > described_class.new(0)).to be true
  end

  it 'Comparable == works on same currency' do
    a = described_class.new(100)
    b = described_class.new(100)
    expect(a).to eq(b)
  end
end
