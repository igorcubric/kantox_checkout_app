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
  let(:order_basket) { %w[CF1 CF1 CF1 GR1 SR1] }
  let(:any_basket) { %w[GR1 SR1 GR1 GR1 CF1] }

  def total_for(arr, rules:, catalog:)
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    arr.each { |c| co.scan(c) }
    co.total
  end

  def subtotal_for(basket)
    basket.tally.sum(Money.zero) { |code, n| catalog.fetch(code).price * n }
  end

  it 'matches subtotal when no rules are applied' do
    basket = %w[GR1 SR1 CF1]
    co = described_class.new(pricing_rules: [], catalog: catalog)
    basket.each { |c| co.scan(c) }
    expect(co.total).to eq(subtotal_for(basket))
  end

  it 'applies discounts when thresholds are met' do
    basket = %w[GR1 GR1 SR1 SR1 SR1 CF1 CF1 CF1]
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    basket.each { |c| co.scan(c) }
    expect(co.total.cents).to be < subtotal_for(basket).cents
  end

  it 'is order-invariant' do
    expect(total_for(order_basket, rules:, catalog:))
      .to eq(total_for(order_basket.shuffle, rules:, catalog:))
  end

  it 'total equals subtotal minus sum(discounts) for any basket' do
    co = described_class.new(pricing_rules: rules, catalog: catalog)
    any_basket.each { |c| co.scan(c) }
    bd = co.breakdown
    expect(bd[:total].cents).to eq(bd[:subtotal].cents - bd[:discounts].sum { |d| d[:amount].cents })
  end
end
