# frozen_string_literal: true

require_relative '../lib/catalog'
require_relative '../lib/pricing/buy_one_get_one_free'
require_relative '../lib/pricing/bulk_price_override'
require_relative '../lib/pricing/group_price_fraction'

RSpec.describe 'Pricing::Rule' do
  let(:catalog) { Catalog.default }

  it 'BOGO gives free floor(count/2) units for GR1' do
    rule = Pricing::BuyOneGetOneFree.new(code: 'GR1')
    items = { 'GR1' => 5 }
    unit  = catalog.fetch('GR1').price
    expected = unit * (items['GR1'] / 2)
    expect(rule.discount_for(items, catalog)).to eq(expected)
  end

  it 'Bulk override lowers price to configured unit when threshold reached' do
    rule  = Pricing::BulkPriceOverride.new(code: 'SR1', threshold: 3, new_unit_price_cents: 450)
    items = { 'SR1' => 3 }
    unit  = catalog.fetch('SR1').price
    expect(rule.discount_for(items, catalog)).to eq((unit * 3) - (Money.new(450) * 3))
  end

  it 'Group fraction charges numerator/denominator of group subtotal' do
    rule  = Pricing::GroupPriceFraction.new(code: 'CF1', threshold: 3, numerator: 2, denominator: 3)
    items = { 'CF1' => 3 }
    unit  = catalog.fetch('CF1').price
    original = unit * 3
    expect(rule.discount_for(items, catalog)).to eq(original - original.scale_by_rational(2, 3))
  end
end
