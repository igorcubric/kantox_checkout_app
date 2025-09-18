# frozen_string_literal: true

require_relative 'money'
require_relative 'product'
require_relative 'catalog'
require_relative 'checkout'
require_relative 'pricing/buy_one_get_one_free'
require_relative 'pricing/bulk_price_override'
require_relative 'pricing/group_price_fraction'

module KantoxCheckoutApp
  VERSION = '0.1.0'
end
