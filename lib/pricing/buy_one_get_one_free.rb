# frozen_string_literal: true

require_relative 'rule'

module Pricing
  # BuyOneGetOneFree: every other unit is extra/free for the given SKU (stock keeping unit)
  class BuyOneGetOneFree < Rule
    attr_reader :code

    def initialize(code:, priority: 100)
      @code = code
      super(priority: priority)
    end

    def discount_for(items, catalog)
      count = items.fetch(@code, 0)
      return Money.zero if count < 2

      unit = catalog.fetch(@code).price
      free_units = count / 2
      unit * free_units
    end
  end
end
