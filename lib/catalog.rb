# frozen_string_literal: true

require_relative 'product'
require_relative 'money'

# Catalog contains an unchangeable mapu code->product and an exists?/fetch API
class Catalog
  def self.default
    new(
      {
        'GR1' => Product.new(code: 'GR1', name: 'Green tea', price: Money.new(311)),
        'SR1' => Product.new(code: 'SR1', name: 'Strawberries', price: Money.new(500)),
        'CF1' => Product.new(code: 'CF1', name: 'Coffee', price: Money.new(1123))
      }
    )
  end

  def initialize(products_by_code)
    @products_by_code = products_by_code.freeze
    freeze
  end

  def exists?(code)
    @products_by_code.key?(code)
  end

  def fetch(code)
    @products_by_code.fetch(code)
  end
end
