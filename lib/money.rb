# frozen_string_literal: true

# Money value object that stores integer cents
# Immutable
class Money
  include Comparable

  attr_reader :cents, :currency

  DEFAULT_CURRENCY = 'GBP'

  def self.zero(currency: DEFAULT_CURRENCY)
    new(0, currency:)
  end

  def initialize(cents, currency: DEFAULT_CURRENCY)
    @cents = Integer(cents)
    @currency = currency
    freeze
  end

  def +(other)
    check_currency!(other)
    Money.new(cents + other.cents, currency:)
  end

  def -(other)
    check_currency!(other)
    Money.new(cents - other.cents, currency:)
  end

  def *(other)
    Money.new(cents * Integer(other), currency:)
  end

  # Scale this amount by a rational factor, rounding to nearest cent (half up).
  # Useful for group discounts like 2/3 of subtotal.
  def scale_by_rational(numerator, denominator)
    scaled = ((cents * numerator).to_r / denominator).round(0) # half-up for Rational
    Money.new(scaled, currency:)
  end

  def <=>(other)
    check_currency!(other)
    cents <=> other.cents
  end

  def zero?
    cents.zero?
  end

  def to_s
    symbol = case currency
             when 'GBP' then '£'
             when 'USD' then '$'
             when 'EUR' then '€'
             else "#{currency} "
             end
    whole, frac = cents.divmod(100)
    format('%<symbol>s%<whole>d.%<frac>02d', symbol:, whole:, frac:)
  end

  private

  def check_currency!(other)
    raise ArgumentError, "Currency mismatch: #{currency} vs #{other.currency}" if currency != other.currency
  end
end
