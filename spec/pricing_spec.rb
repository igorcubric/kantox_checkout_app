# frozen_string_literal: true

require_relative '../lib/catalog'
require_relative '../lib/pricing/buy_one_get_one_free'
require_relative '../lib/pricing/bulk_price_override'
require_relative '../lib/pricing/group_price_fraction'

RSpec.describe Pricing do
  describe Pricing::BuyOneGetOneFree do
    let(:params) { { code: 'GR1' } }

    it_behaves_like 'a pricing rule',
                    sku: 'GR1',
                    below: 1,
                    at_or_above: 4,
                    compute_expected: ->(unit, n) { unit * (n / 2) }
  end

  describe Pricing::BulkPriceOverride do
    let(:params) { { code: 'SR1', threshold: 3, new_unit_price_cents: 450 } }

    it_behaves_like 'a pricing rule',
                    sku: 'SR1',
                    below: 2,
                    at_or_above: 3,
                    compute_expected: ->(unit, n) { (unit * n) - (Money.new(450) * n) }
  end

  describe Pricing::GroupPriceFraction do
    let(:params) { { code: 'CF1', threshold: 3, numerator: 2, denominator: 3 } }

    it_behaves_like 'a pricing rule',
                    sku: 'CF1',
                    below: 2,
                    at_or_above: 3,
                    compute_expected: (lambda do |unit, n|
                      group  = unit * n
                      target = group.scale_by_rational(2, 3)
                      group - target
                    end)
  end
end
