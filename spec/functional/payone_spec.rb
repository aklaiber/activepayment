require "spec_helper"

describe ActivePayment::Payone::Gateway do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Payone::Gateway.new(amount) }

  before(:each) do
    gateway.transaction_params = {
        :aid => 18270,
        :clearingtype => 'cc',
        :cardholder => "John Doe",
        :cardexpiredate => "1202",
        :cardtype => "V",
        :cardpan => "4901170005495083",
        :cardcvc2 => 233,
        :lastname => 'Doe',
        :firstname => 'John',
        :country => 'DE',
        :productid => 4893,
        :amount => amount,
        :reference => 'test'
    }
  end

  describe "Portal Zugang" do

    let(:payone_response) { gateway.createaccess(:reference => Time.now.to_i + rand(10000)) }
    let(:payone_user_id) { payone_response.userid }
    let(:payone_access_id) { payone_response.accessid }

    before(:all) do
      ActivePayment::Payone::Gateway.mid = 18268
      ActivePayment::Payone::Gateway.portalid = 2226
      ActivePayment::Payone::Gateway.key = 'test'
      ActivePayment::Payone::Gateway.mode = 'test'
      ActivePayment::Payone::Gateway.default_currency = 'EUR'
    end

    it "should post createaccess request" do
      response = gateway.createaccess(:reference => Time.now.to_i + rand(10000))

      response.successful?.should be_true
    end

    it "should post updateuser request" do
      response = gateway.updateuser(:userid => payone_user_id, :street => "teststr.1")

      response.successful?.should be_true
    end

    it "should post updateaccess request" do
      response = gateway.updateaccess(:accessid  => payone_access_id, :action => 'update')

      response.successful?.should be_true
    end

  end

  describe "Portal Shop" do
    before(:all) do
      ActivePayment::Payone::Gateway.mid = 18268
      ActivePayment::Payone::Gateway.portalid = 2013125
      ActivePayment::Payone::Gateway.key = 'test'
      ActivePayment::Payone::Gateway.mode = 'test'
      ActivePayment::Payone::Gateway.default_currency = 'EUR'
    end

    it "should post authorization request" do
      response = gateway.authorization(:reference => Time.now.to_i + rand(10000))

      response.successful?.should be_true
    end
  end

end
