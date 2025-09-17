# frozen_string_literal: true

require_relative 'money'
require_relative 'product'
require_relative 'catalog'
require_relative 'pricing/rule'
require_relative 'pricing/buy_one_get_one_free'
require_relative 'pricing/bulk_price_override'
require_relative 'pricing/group_price_fraction'

# Checkout aggregates points and applies pricing rules on the catalogue
class Checkout
  # unknown_sku: :error or :skip
  def initialize(pricing_rules:, catalog: Catalog.default, unknown_sku: :error)
    @pricing_rules = Array(pricing_rules).freeze
    @catalog       = catalog
    @items         = Hash.new(0) # code => count
    @unknown_sku   = unknown_sku
  end

  # Accepts code or Product
  def scan(item)
    code = item.is_a?(Product) ? item.code : String(item)
    unless @catalog.exists?(code)
      case @unknown_sku
      when :error then raise KeyError, "Unknown SKU: #{code}"
      when :skip  then return self
      else raise ArgumentError, 'unknown_sku must be :error or :skip'
      end
    end
    @items[code] += 1
    self
  end

  def remove(item)
    code = item.is_a?(Product) ? item.code : String(item)
    return self unless @items.key?(code)

    @items[code] -= 1
    @items.delete(code) if @items[code] <= 0
    self
  end

  def clear
    @items.clear
    self
  end

  def items
    @items.dup
  end

  def breakdown
    subtotal   = compute_subtotal
    discounts  = compute_discounts
    total_cents = subtotal.cents - sum_discount_cents(discounts)
    { subtotal: subtotal, discounts: discounts, total: Money.new(total_cents) }
  end

  def total
    breakdown[:total]
  end

  private

  def compute_subtotal
    @items.sum(Money.zero) { |code, count| @catalog.fetch(code).price * count }
  end

  def compute_discounts
    @pricing_rules
      .sort_by(&:priority)
      .filter_map { |rule| discount_entry(rule) }
  end

  def discount_entry(rule)
    amount = rule.discount_for(@items, @catalog)
    return nil if amount.zero?

    code = rule.respond_to?(:code) ? rule.code : nil
    { label: rule.label, code: code, amount: amount }
  end

  def sum_discount_cents(discounts)
    discounts.sum { |d| d[:amount].cents }
  end
end
