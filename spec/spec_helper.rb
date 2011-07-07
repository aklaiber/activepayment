$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'active_payment'
require 'rspec'
require 'factory_girl'

FIXTURES_PATH = "#{File.dirname(__FILE__)}/fixtures"

RSpec.configure do |config|
  config.mock_framework = :rspec
end

def credit_card(number = '4200000000000000', options = {})
  {
      :number => number,
      :month => 9,
      :year => Time.now.year + 1,
      :first_name => 'Longbob',
      :last_name => 'Longsen',
      :verification_value => '123',
      :type => 'visa'
  }.update(options)
end
