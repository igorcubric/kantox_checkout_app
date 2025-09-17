# frozen_string_literal: true

require_relative '../lib/checkout'
require_relative '../lib/catalog'

RSpec.describe Checkout do
  let(:catalog) { Catalog.default }
  let(:rules) do
    [
      Pricing::BuyOneGetOneFree.new(code: 'GR1'),
      Pricing::BulkPriceOverride.new(code: 'SR1', threshold: 3, new_unit_price_cents: 450),
      Pricing::GroupPriceFraction.new(code: 'CF1', threshold: 3, numerator: 2, denominator: 3)
    ]
  end

  it 'basket: GR1,SR1,GR1,GR1,CF1 -> £22.45' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    %w[GR1 SR1 GR1 GR1 CF1].each { |c| co.scan(c) }
    expect(co.total.to_s).to eq('£22.45')
  end

  it 'basket: GR1,GR1 -> £3.11' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    %w[GR1 GR1].each { |c| co.scan(c) }
    expect(co.total.to_s).to eq('£3.11')
  end

  it 'basket: SR1,SR1,GR1,SR1 -> £16.61' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    %w[SR1 SR1 GR1 SR1].each { |c| co.scan(c) }
    expect(co.total.to_s).to eq('£16.61')
  end

  it 'basket: GR1,CF1,SR1,CF1,CF1 -> £30.57' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    %w[GR1 CF1 SR1 CF1 CF1].each { |c| co.scan(c) }
    expect(co.total.to_s).to eq('£30.57')
  end

  it 'is order-invariant' do
    a = described_class.new(pricing_rules: rules, catalog: catalog)
    b = described_class.new(pricing_rules: rules, catalog: catalog)
    %w[CF1 CF1 CF1 GR1 SR1].each { |c| a.scan(c) }
    %w[SR1 CF1 GR1 CF1 CF1].shuffle.each { |c| b.scan(c) }
    expect(a.total).to eq(b.total)
  end
end
