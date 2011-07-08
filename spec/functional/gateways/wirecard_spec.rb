require "spec_helper"

describe ActivePayment::Gateway::Wirecard do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Gateway::Wirecard.new(123, amount) }

  before(:all) do
    ActivePayment::Gateway::Wirecard.login = 56501
    ActivePayment::Gateway::Wirecard.password = "TestXAPTER"
    ActivePayment::Gateway::Wirecard.signature = "56501"
    ActivePayment::Gateway::Wirecard.mode = "demo"
    ActivePayment::Gateway::Wirecard.default_currency = 'EUR'

    gateway.jop_id = 'test dummy data'
    gateway.transaction_params = {
        :commerce_type => 'eCommerce',
        :country_code => 'DE'
    }
  end

  it "should post authorization request" do
    response = gateway.authorization(credit_card_hash)

    response.successful?.should be_true
    response.info.should include('THIS IS A DEMO')
    response.status_type.should eql('INFO')
    response.authorization_code.should_not be_blank
    response['GuWID'].should_not be_blank
  end

  it "should post capture_authorization request" do
    guwid = gateway.authorization(credit_card_hash)['GuWID']
    response = gateway.capture_authorization(guwid)

    response.successful?.should be_true
    response.info.should include('THIS IS A DEMO')
    response.status_type.should eql('INFO')
    response.authorization_code.should_not be_blank
    response['GuWID'].should_not be_blank
  end

  it "should post purchase request" do
    response = gateway.purchase(credit_card_hash)

    response.successful?.should be_true
    response.info.should include('THIS IS A DEMO')
    response.status_type.should eql('INFO')
    response.authorization_code.should_not be_blank
    response['GuWID'].should_not be_blank
  end

  describe "3D secure" do

    before(:all) do
      ActivePayment::Gateway::Wirecard.login = '000000315DE09F66'
      ActivePayment::Gateway::Wirecard.password = 'TestXAPTER'
      ActivePayment::Gateway::Wirecard.signature = '000000315DE0A429'
      ActivePayment::Gateway::Wirecard.mode = ''
    end

    it "should post enrollment_check request" do
      response = gateway.enrollment_check(credit_card_hash('4012000300001003', :cvc2 => '003'))

      response.successful?.should be_true
      response.status_type.should eql('Y')
      response['GuWID'].should_not be_blank
      response['AcsUrl'].should_not be_blank
    end

  end

end