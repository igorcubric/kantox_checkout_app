# frozen_string_literal: true

require_relative '../lib/checkout'
require_relative '../lib/catalog'

RSpec.describe Checkout do
  let(:catalog) { Catalog.default }
  let(:rules) do
    [
      Pricing::BuyOneGetOneFree.new(code: 'GR1', priority: 50),
      Pricing::BulkPriceOverride.new(code: 'SR1', threshold: 3, new_unit_price_cents: 450, priority: 60),
      Pricing::GroupPriceFraction.new(code: 'CF1', threshold: 3, numerator: 2, denominator: 3, priority: 70)
    ]
  end
  let(:basket) { %w[GR1 GR1 SR1 SR1 SR1 CF1 CF1 CF1] }

  it 'computes expected subtotal' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    basket.each { |c| co.scan(c) }
    bd = co.breakdown
    expected_subtotal = basket.tally.sum(Money.zero) { |code, n| catalog.fetch(code).price * n }
    expect(bd[:subtotal]).to eq(expected_subtotal)
  end

  it 'applies rules in priority order' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    basket.each { |c| co.scan(c) }
    labels = co.breakdown[:discounts].map { |d| d[:label] }
    expect(labels).to eq(%w[BuyOneGetOneFree BulkPriceOverride GroupPriceFraction])
  end

  it 'satisfies subtotal - discounts == total' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    basket.each { |c| co.scan(c) }
    bd = co.breakdown
    sum_cents = bd[:discounts].sum { |d| d[:amount].cents }
    expect(bd[:total].cents).to eq(bd[:subtotal].cents - sum_cents)
  end
end
