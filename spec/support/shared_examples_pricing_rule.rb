# frozen_string_literal: true

RSpec.shared_examples 'a pricing rule' do |sku:, below:, at_or_above:, compute_expected:|
  let(:catalog) { Catalog.default }

  it 'is zero below threshold' do
    items = { sku => below }
    d = described_class.new(**params).discount_for(items, catalog)
    expect(d.cents).to eq(0)
  end

  it 'is non-negative at or above threshold' do
    items = { sku => at_or_above }
    d = described_class.new(**params).discount_for(items, catalog)
    expect(d.cents).to be >= 0
  end

  # rubocop:disable RSpec/ExampleLength
  it 'matches formula at or above threshold', :aggregate_failures do
    items = { sku => at_or_above }
    unit  = catalog.fetch(sku).price
    expected = compute_expected.call(unit, at_or_above)
    actual   = described_class.new(**params).discount_for(items, catalog)
    expect(actual.cents).to eq(expected.cents)
    expect(actual.currency).to eq(expected.currency)
  end
  # rubocop:enable RSpec/ExampleLength
end
