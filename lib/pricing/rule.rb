# frozen_string_literal: true

require_relative '../money'

module Pricing
  # Abstract pricing rule
  # Implements #discount_for(items, catalog) -> Money
  class Rule
    attr_reader :priority

    def initialize(priority: 100)
      @priority = Integer(priority)
      freeze
    end

    def discount_for(_items, _catalog)
      raise NotImplementedError
    end

    def label
      self.class.name.split('::').last
    end
  end
end
