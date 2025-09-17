# frozen_string_literal: true

require_relative 'money'

# Product entity with code, name, and unit price
class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code  = String(code)
    @name  = String(name)
    @price = price # Money
    freeze
  end
end
