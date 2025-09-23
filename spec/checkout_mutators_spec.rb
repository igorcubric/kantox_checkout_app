# frozen_string_literal: true

require 'checkout'
require 'catalog'

RSpec.describe Checkout do
  include_context 'with catalog and rules'

  it 'removes one item' do
    co = described_class.new(pricing_rules: [], catalog: catalog)
    co.scan('GR1').scan('GR1').scan('SR1')
    co.remove('GR1')
    expect(co.items).to eq({ 'GR1' => 1, 'SR1' => 1 })
  end

  it 'deletes key when count hits zero' do
    co = described_class.new(pricing_rules: [], catalog: catalog)
    co.scan('GR1')
    co.remove('GR1')
    expect(co.items).to eq({})
  end
end
