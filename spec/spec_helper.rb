$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "activepayment"
require "rspec"
require "forgery"

FIXTURES_PATH = "#{File.dirname(__FILE__)}/fixtures"

RSpec.configure do |config|
  config.mock_framework = :rspec
end

def credit_card_hash(number = '4200000000000000', options = {})
  {
      :credit_card_number => number,
      :cvc2 => '001',
      :expiration_year => Time.now.year + 1,
      :expiration_month => '01',
      :card_holder_name => Forgery::Name.full_name
  }.update(options)
end