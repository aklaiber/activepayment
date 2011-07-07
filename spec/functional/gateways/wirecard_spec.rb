require "spec_helper"

describe ActivePayment::Gateway::Wirecard do
  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Gateway::Wirecard.new(amount) }

  before(:all) do
    ActivePayment::Gateway::Wirecard.login = 56501
    ActivePayment::Gateway::Wirecard.password = "TestXAPTER"
    ActivePayment::Gateway::Wirecard.signature = "56501"
    ActivePayment::Gateway::Wirecard.mode = "demo"
    ActivePayment::Gateway::Wirecard.default_currency = 'EUR'

    gateway.jop_id = 'test dummy data'
    gateway.transaction_params = {
        :transaction_id => 123,
        :commerce_type => 'eCommerce',
        :amount => amount,
        :country_code => 'DE'
    }
  end

  it "should post authorization request" do
    gateway.authorization(credit_card_hash)
  end

end