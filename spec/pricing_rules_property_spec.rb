# frozen_string_literal: true

require 'rantly'
require 'rantly/rspec_extensions'
require_relative '../lib/catalog'
require_relative '../lib/money'
require_relative '../lib/pricing/buy_one_get_one_free'
require_relative '../lib/pricing/bulk_price_override'
require_relative '../lib/pricing/group_price_fraction'

RSpec.describe Pricing do
  let(:catalog) { Catalog.default }

  describe Pricing::BuyOneGetOneFree do
    subject(:rule) { described_class.new(code: 'GR1') }

    let(:unit) { catalog.fetch('GR1').price }

    it 'matches unit * (n/2) for GR1' do
      property_of { range(0, 200) }.check do |n|
        expect(rule.discount_for({ 'GR1' => n }, catalog)).to eq(unit * (n / 2))
      end
    end
  end

  describe Pricing::BulkPriceOverride do
    subject(:rule) { described_class.new(code: 'SR1', threshold: 3, new_unit_price_cents: 450) }

    let(:unit) { catalog.fetch('SR1').price }
    let(:newp) { Money.new(450) }

    it 'is zero below threshold and linear at/above' do
      property_of { range(0, 200) }.check do |n|
        expected = n < 3 ? Money.zero : (unit * n) - (newp * n)
        expect(rule.discount_for({ 'SR1' => n }, catalog)).to eq(expected)
      end
    end
  end

  describe Pricing::GroupPriceFraction do
    subject(:rule) { described_class.new(code: 'CF1', threshold: 3, numerator: 2, denominator: 3) }

    let(:unit) { catalog.fetch('CF1').price }

    it 'is zero below threshold and proportional at/above' do
      property_of { range(0, 200) }.check do |n|
        original = unit * n
        expected = n < 3 ? Money.zero : original - original.scale_by_rational(2, 3)
        expect(rule.discount_for({ 'CF1' => n }, catalog)).to eq(expected)
      end
    end
  end
end
