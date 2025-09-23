# frozen_string_literal: true

require_relative '../lib/checkout'
require_relative '../lib/catalog'

RSpec.describe Checkout do
  include_context 'with catalog and rules'

  # rubocop:disable RSpec/ExampleLength
  it 'produces correct subtotal' do
    basket = %w[GR1 GR1 SR1 SR1 SR1 CF1 CF1 CF1]
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    scan_all(co, basket)
    bd = co.breakdown
    expected_subtotal = subtotal_for(catalog, basket)
    expect(bd[:subtotal]).to match_money(expected_subtotal)
  end

  it 'produces total = subtotal - sum(discounts)' do
    basket = %w[GR1 GR1 SR1 SR1 SR1 CF1 CF1 CF1]
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    scan_all(co, basket)
    bd = co.breakdown
    sum_discounts = bd[:discounts].sum { |d| d[:amount].cents }
    expect(bd[:total].cents).to eq(bd[:subtotal].cents - sum_discounts)
  end
  # rubocop:enable RSpec/ExampleLength

  it 'lists discounts in priority order' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    scan_all(co, %w[GR1 GR1 SR1 SR1 SR1 CF1 CF1 CF1])
    labels = co.breakdown[:discounts].map { |d| d[:label] }
    expect(labels).to eq(%w[BuyOneGetOneFree BulkPriceOverride GroupPriceFraction])
  end
end
