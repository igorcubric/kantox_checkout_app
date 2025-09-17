# frozen_string_literal: true

require_relative 'rule'

module Pricing
  # GroupPriceFraction: for n or more, group subtotal scales to p/q originals
  class GroupPriceFraction < Rule
    attr_reader :code

    def initialize(code:, threshold:, numerator:, denominator:, priority: 100)
      @code = code
      @threshold = Integer(threshold)
      @numerator = Integer(numerator)
      @denominator = Integer(denominator)
      super(priority: priority)
    end

    def discount_for(items, catalog)
      count = items.fetch(@code, 0)
      return Money.zero if count < @threshold

      unit = catalog.fetch(@code).price
      original = unit * count
      target = original.scale_by_rational(@numerator, @denominator)
      original - target
    end
  end
end
