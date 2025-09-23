# frozen_string_literal: true

RSpec::Matchers.define :match_money do |expected|
  match do |actual|
    case expected
    when Money   then actual.cents == expected.cents && actual.currency == expected.currency
    when Integer then actual.cents == expected
    when String  then actual.to_s == expected
    else false
    end
  end

  failure_message do |actual|
    "expected #{expected.inspect} but got #{actual} (#{actual.cents} cents)"
  end
end
