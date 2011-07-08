require 'spec_helper'

describe ActivePayment::Gateway::Wirecard do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Gateway::Wirecard.new(123, amount) }
  let(:guwid) { 'C822580121385121429927' }

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

  it "should build authorization request" do
    File.open("#{FIXTURES_PATH}/gateways/wirecard/authorization_request.xml") do |xml_file|
      gateway.authorization_request(credit_card_hash('4200000000000000', :expiration_year => 2009, :card_holder_name => 'John Doe')).should eql(xml_file.read)
    end
  end

  it "should build capture_authorization request" do
    File.open("#{FIXTURES_PATH}/gateways/wirecard/capture_authorization_request.xml") do |xml_file|
      gateway.capture_authorization_request(guwid).should eql(xml_file.read)
    end
  end

  it "should build purchase request" do
    File.open("#{FIXTURES_PATH}/gateways/wirecard/purchase_request.xml") do |xml_file|
      gateway.purchase_request(credit_card_hash('4200000000000000', :expiration_year => 2009, :card_holder_name => 'John Doe')).should eql(xml_file.read)
    end
  end

  it "should build enrollment check request" do
    File.open("#{FIXTURES_PATH}/gateways/wirecard/enrollment_check_request.xml") do |xml_file|
      gateway.enrollment_check_request(credit_card_hash('4200000000000000', :expiration_year => 2009, :card_holder_name => 'John Doe')).should eql(xml_file.read)
    end
  end

  describe "with address" do
    before(:all) do
      gateway.transaction_params = {
          :commerce_type => 'eCommerce',
          :country_code => 'DE',
          :contact_data => {:ip_address => '192.168.1.1'},
          :corptrustcenter_data => {
              :address => {
                  :first_name => 'John',
                  :last_name => 'Doe',
                  :address_1 => '550 South Winchester blvd.',
                  :address_2 => 'P.O. Box 850',
                  :city => 'San Jose',
                  :zip_code => '95128',
                  :state => 'CA',
                  :country => 'US',
                  :phone => '+1(202)555-1234',
                  :email => 'John.Doe@email.com'
              }
          }
      }
    end

    it "should build authorization request" do
      File.open("#{FIXTURES_PATH}/gateways/wirecard/authorization_request_with_address.xml") do |xml_file|
        gateway.authorization_request(credit_card_hash('4200000000000000', :expiration_year => 2009, :card_holder_name => 'John Doe')).should eql(xml_file.read)
      end
    end
  end

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