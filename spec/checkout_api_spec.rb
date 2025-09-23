# frozen_string_literal: true

require_relative '../lib/checkout'
require_relative '../lib/catalog'

RSpec.describe Checkout do
  include_context 'with catalog and rules'

  it 'matches subtotal when no rules are applied' do
    basket = %w[GR1 SR1 CF1]
    co = described_class.new(pricing_rules: [], catalog: catalog)
    scan_all(co, basket)
    expect(co.total).to match_money(subtotal_for(catalog, basket))
  end

  it 'applies discounts when thresholds are met' do
    basket = %w[GR1 GR1 SR1 SR1 SR1 CF1 CF1 CF1]
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    scan_all(co, basket)
    expect(co.total.cents).to be < subtotal_for(catalog, basket).cents
  end

  # rubocop:disable RSpec/ExampleLength
  it 'is order-invariant' do
    basket = %w[SR1 CF1 GR1 CF1 CF1]
    a = described_class.new(pricing_rules: rules, catalog: catalog)
    b = described_class.new(pricing_rules: rules, catalog: catalog)
    scan_all(a, basket)
    scan_all(b, basket.shuffle)
    expect(a.total).to match_money(b.total)
  end

  it 'total equals subtotal minus sum(discounts) for any basket' do
    basket = %w[GR1 GR1 SR1 SR1 SR1 CF1 CF1 CF1]
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    scan_all(co, basket)
    bd = co.breakdown
    sum_discounts = bd[:discounts].sum { |d| d[:amount].cents }
    expect(bd[:total].cents).to eq(bd[:subtotal].cents - sum_discounts)
  end
  # rubocop:enable RSpec/ExampleLength
end
