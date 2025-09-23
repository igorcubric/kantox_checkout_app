# frozen_string_literal: true

RSpec.shared_context 'with catalog and rules' do
  let(:catalog) { Catalog.default }
  let(:rules) do
    [
      Pricing::BuyOneGetOneFree.new(code: 'GR1', priority: 50),
      Pricing::BulkPriceOverride.new(code: 'SR1', threshold: 3, new_unit_price_cents: 450, priority: 60),
      Pricing::GroupPriceFraction.new(code: 'CF1', threshold: 3, numerator: 2, denominator: 3, priority: 70)
    ]
  end
end
