require "spec_helper"

describe ActivePayment::Wirecard::Gateway do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Wirecard::Gateway.new(123, amount) }

  describe "post request" do

    before(:all) do
      ActivePayment::Wirecard::Gateway.login = 56501
      ActivePayment::Wirecard::Gateway.password = "TestXAPTER"
      ActivePayment::Wirecard::Gateway.signature = "56501"
      ActivePayment::Wirecard::Gateway.mode = "demo"
      ActivePayment::Wirecard::Gateway.default_currency = 'EUR'

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

    describe "with address" do
      before(:all) do
        gateway.transaction_params = {
            :commerce_type => 'eCommerce',
            :country_code => 'DE',
            :contact_data => {:ip_address => '192.168.1.1'},
            :corptrustcenter_data => {
                :address => {
                    :first_name => Forgery::Name.first_name,
                    :last_name => Forgery::Name.last_name,
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

      it "should post authorization request with address" do
        response = gateway.authorization(credit_card_hash)

        response.successful?.should be_true
        response.info.should include('THIS IS A DEMO')
        response.status_type.should eql('INFO')
        response.authorization_code.should_not be_blank
        response['GuWID'].should_not be_blank
      end
    end
  end

  describe "3D secure" do

    before(:all) do
      ActivePayment::Wirecard::Gateway.login = '000000315DE09F66'
      ActivePayment::Wirecard::Gateway.password = 'TestXAPTER'
      ActivePayment::Wirecard::Gateway.signature = '000000315DE0A429'
      ActivePayment::Wirecard::Gateway.mode = ''

      gateway.jop_id = 'test dummy data'
      gateway.transaction_params = {
          :commerce_type => 'eCommerce',
          :country_code => 'DE'
      }
    end

    it "should post enrollment_check request" do
      response = gateway.enrollment_check(credit_card_hash('4012000300001003', :cvc2 => '003'))

      response.successful?.should be_true
      response.status_type.should eql('Y')
      response['GuWID'].should_not be_blank
      response['PAReq'].should_not be_blank
      response['AcsUrl'].should_not be_blank
    end

  end

end