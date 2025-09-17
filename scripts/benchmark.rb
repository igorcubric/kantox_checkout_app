# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'benchmark/ips'
require 'checkout'
require 'catalog'
require 'pricing/buy_one_get_one_free'
require 'pricing/bulk_price_override'
require 'pricing/group_price_fraction'

rules = [
  Pricing::BuyOneGetOneFree.new(code: 'GR1'),
  Pricing::BulkPriceOverride.new(code: 'SR1', threshold: 3, new_unit_price_cents: 450),
  Pricing::GroupPriceFraction.new(code: 'CF1', threshold: 3, numerator: 2, denominator: 3)
]

catalog = Catalog.default
basket = Array.new(1_000) { %w[GR1 SR1 CF1].sample }

Benchmark.ips do |x|
  x.report('total(1000 items)') do
    co = Checkout.new(pricing_rules: rules, catalog: catalog)
    basket.each { |c| co.scan(c) }
    co.total
  end
  x.compare!
end
