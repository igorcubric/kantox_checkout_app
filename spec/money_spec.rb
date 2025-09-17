# frozen_string_literal: true

require_relative '../lib/money'

RSpec.describe Money do
  it 'adds and subtracts' do
    a = described_class.new(311)
    b = described_class.new(200)

    expect((a + b).cents).to eq(511)
  end

  it 'subtracts' do
    a = described_class.new(311)
    b = described_class.new(200)

    expect((a - b).cents).to eq(111)
  end

  it 'multiplies by integer' do
    a = described_class.new(311)

    expect((a * 3).cents).to eq(933)
  end

  it 'scales by rational' do
    a = described_class.new(3369) # 3 coffees at 11.23

    expect(a.scale_by_rational(2, 3).cents).to eq(2246) # exact 2/3 without drift
  end

  it 'stringifies with GBP symbol' do
    expect(described_class.new(311).to_s).to eq('£3.11')
  end
end
