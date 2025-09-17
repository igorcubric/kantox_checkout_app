# frozen_string_literal: true

require_relative 'rule'

module Pricing
  # BulkPriceOverride: from the threshold below, copy the unit price to the predefined value
  class BulkPriceOverride < Rule
    attr_reader :code

    def initialize(code:, threshold:, new_unit_price_cents:, priority: 100)
      @code = code
      @threshold = Integer(threshold)
      @new_price = Money.new(Integer(new_unit_price_cents))
      super(priority: priority)
    end

    def discount_for(items, catalog)
      count = items.fetch(@code, 0)
      return Money.zero if count < @threshold

      orig_unit = catalog.fetch(@code).price
      original  = orig_unit * count
      target    = @new_price * count
      original - target
    end
  end
end
