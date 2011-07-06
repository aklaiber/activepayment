require 'spec_helper'

describe ActivePayment::Gateway::Wirecard do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Gateway::Wirecard.new(amount) }

#  before(:all) do
#    ActivePayment::Gateway::Wirecard.login = 56501
#    ActivePayment::Gateway::Wirecard.password = "TestXAPTER"
#    ActivePayment::Gateway::Wirecard.signature = "56501"
#
##    ActivePayment::Gateway::Wirecard.config = {:login => 56501}
##    ActivePayment::Gateway::Wirecard.config do |c|
##      c.login = 56501
##    end
#  end


  it "should build authorization request" do
#    gateway.purchase_options :ip => ip_address, :billing_address => {
#        :name => "#{sender_user[:firstname]} #{sender_user[:lastname]}",
#        :address1 => sender_user[:street],
#        :city => sender_user[:city],
#        :country => "DE",
#        :zip => sender_user[:zip_code],
#        :email => Forgery::Internet.email_address
#    }

    File.open("#{FIXTURES_PATH}/gateways/wirecard/authorization_request.xml") do |xml_file|
      gateway.authorization_request(credit_card).should eql(xml_file.read)
    end
  end

  it "should build capture request"
  it "should build purchase request"
end