require 'spec_helper'

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

  it "should build authorization request" do
    File.open("#{FIXTURES_PATH}/gateways/wirecard/authorization_request.xml") do |xml_file|
      gateway.authorization_request(credit_card_hash('4200000000000000', :expiration_year => 2009, :card_holder_name => 'John Doe')).should eql(xml_file.read)
    end
  end

  it "should build capture request"
  it "should build purchase request"

  describe "config" do
    it 'should set by methods' do
      ActivePayment::Gateway::Wirecard.login = 56501
      ActivePayment::Gateway::Wirecard.password = "TestXAPTER"
      ActivePayment::Gateway::Wirecard.signature = 56501

      ActivePayment::Gateway::Wirecard.login.should eql(56501)
      ActivePayment::Gateway::Wirecard.password.should eql("TestXAPTER")
      ActivePayment::Gateway::Wirecard.signature.should eql(56501)
    end

    it 'should set by hash' do
      ActivePayment::Gateway::Wirecard.config = {:login => 56502, :password => "TestXAPTERR", :signature => 56502}

      ActivePayment::Gateway::Wirecard.login.should eql(56502)
      ActivePayment::Gateway::Wirecard.password.should eql("TestXAPTERR")
      ActivePayment::Gateway::Wirecard.signature.should eql(56502)
    end

    it 'should set by block' do
      ActivePayment::Gateway::Wirecard.config do |c|
        c.login = 56503
        c.password = "TestXAPTERR"
        c.signature = 56503
      end

      ActivePayment::Gateway::Wirecard.login.should eql(56503)
      ActivePayment::Gateway::Wirecard.password.should eql("TestXAPTERR")
      ActivePayment::Gateway::Wirecard.signature.should eql(56503)
    end
  end

end