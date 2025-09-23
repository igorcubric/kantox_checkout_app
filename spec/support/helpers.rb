# frozen_string_literal: true

module SpecHelpers
  def scan_all(checkout, codes)
    codes.each { |c| checkout.scan(c) }
    checkout
  end

  def subtotal_for(catalog, basket)
    basket.tally.sum(Money.zero) { |code, n| catalog.fetch(code).price * n }
  end

  def total_for(catalog, rules, basket)
    co = Checkout.new(pricing_rules: rules, catalog: catalog)
    scan_all(co, basket)
    co.total
  end
end

RSpec.configure { |c| c.include SpecHelpers }
