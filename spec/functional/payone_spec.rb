require "spec_helper"

describe ActivePayment::Payone::Gateway do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Payone::Gateway.new(amount) }

  describe "Portal Zugang" do

    before(:all) do
      ActivePayment::Payone::Gateway.mid = 18268
      ActivePayment::Payone::Gateway.portalid = 2226
      ActivePayment::Payone::Gateway.key = 'test'
      ActivePayment::Payone::Gateway.mode = "test"
      ActivePayment::Payone::Gateway.default_currency = 'EUR'

      gateway.aid = 18270
      gateway.transaction_params = {
          :clearingtype => 'cc',
          :cardholder => "John Doe",
          :cardexpiredate => "1202",
          :cardtype => "V",
          :cardpan => "4901170005495083",
          :cardcvc2 => 233,
          :reference => "00000000000000000001",
      }
    end


  end

  describe "Portal Shop" do
    before(:all) do
      ActivePayment::Payone::Gateway.mid = 18268
      ActivePayment::Payone::Gateway.portalid = 2013125
      ActivePayment::Payone::Gateway.key = 'test'
      ActivePayment::Payone::Gateway.mode = 'test'
      ActivePayment::Payone::Gateway.default_currency = 'EUR'

      gateway.aid = 18270
      gateway.transaction_params = {
          :clearingtype => 'cc',
          :cardholder => "John Doe",
          :cardexpiredate => "1202",
          :cardtype => "V",
          :cardpan => "4901170005495083",
          :cardcvc2 => 233,
          :reference => rand(10000),
          :lastname => 'Doe',
          :firstname => 'John',
          :country => 'DE'
      }
    end

    it "should post authorization request" do
      response = gateway.authorization

      response.successful?.should be_true
#      response.info.should include('THIS IS A DEMO')
#      response.status_type.should eql('INFO')
#      response.authorization_code.should_not be_blank
#      response['GuWID'].should_not be_blank
    end
  end

end