require 'spec_helper'

describe ActivePayment::Payone::Gateway do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Payone::Gateway.new(amount) }

  before(:all) do
    ActivePayment::Payone::Gateway.mid = 18268
    ActivePayment::Payone::Gateway.portalid = 2226
    ActivePayment::Payone::Gateway.key = 'test'
    ActivePayment::Payone::Gateway.mode = "test"

    gateway.transaction_params = {
        :aid => 18270,
        :productid => 123,
        :clearingtype => 'cc',
        :cardholder => "John Doe",
        :cardexpiredate => "1202",
        :cardtype => "V",
        :cardpan => "4901170005495083",
        :cardcvc2 => 233,
        :reference => "00000000000000000001",
        :amount => amount
    }
  end

  it "should build authorization request" do
    request = gateway.authorization_request

    request.should_not be_blank
    request.should include('request=authorization')
    request.should include('aid=18270')
    request.should include('clearingtype=cc')
    request.should include('reference=00000000000000000001')
    request.should include('amount=100')
    request.should include('currency=EUR')
  end

  it "should build createaccess request" do
    request = gateway.createaccess_request

    request.should_not be_blank
    request.should include('request=createaccess')
    request.should include('aid=18270')
    request.should include('clearingtype=cc')
    request.should include('reference=00000000000000000001')
    request.should include('productid=123')
  end

  it "should build updateuser request" do
    request = gateway.updateuser_request(:userid => 123)

    request.should_not be_blank
    request.should include('request=updateuser')
    request.should include('userid=123')
  end

  it "should build updateaccess request" do
    request = gateway.updateaccess_request(:accessid => 123, :action => 'update')

    request.should_not be_blank
    request.should include('request=updateaccess')
    request.should include('accessid=123')
    request.should include('action=update')
  end

  it "should build 3dscheck request" do
    request = gateway.threedscheck_request(:cardpan => "4111111111111111", :exiturl => "http://www.example.com")

    request.should_not be_blank
    request.should include('request=3dscheck')
    request.should include('amount=100')
    request.should include('currency=EUR')
    request.should include('clearingtype=cc')
    request.should include('exiturl=http%3A%2F%2Fwww.example.com')
    request.should include('cardpan=4111111111111111')
    request.should include('cardtype=V')
  end

  it "should build updatereminder request" do
    request = gateway.updatereminder_request(:txid  => 123, :reminderlevel => 2)

    request.should_not be_blank
    request.should include('txid=123')
    request.should include('reminderlevel=2')
  end

  it "should get exception if forget mandatory parameter" do
    gateway.transaction_params.delete(:reference)
    lambda { gateway.createaccess_request }.should raise_exception(ActivePayment::Exception, "Payone API Parameters not complete: reference not exists")
  end

  describe "config" do
    it 'should set by methods' do
      ActivePayment::Payone::Gateway.mid = 1
      ActivePayment::Payone::Gateway.portalid = 2
      ActivePayment::Payone::Gateway.key = "test_key"

      ActivePayment::Payone::Gateway.mid.should eql(1)
      ActivePayment::Payone::Gateway.portalid.should eql(2)
      ActivePayment::Payone::Gateway.key.should eql("test_key")
    end

    it 'should set by hash' do
      ActivePayment::Payone::Gateway.config = {:mid => 1, :portalid => 2, :key => "test_key"}

      ActivePayment::Payone::Gateway.mid.should eql(1)
      ActivePayment::Payone::Gateway.portalid.should eql(2)
      ActivePayment::Payone::Gateway.key.should eql("test_key")
    end

    it 'should set by block' do
      ActivePayment::Payone::Gateway.config do |c|
        c.mid = 1
        c.portalid = 2
        c.key = "test_key"
      end

      ActivePayment::Payone::Gateway.mid.should eql(1)
      ActivePayment::Payone::Gateway.portalid.should eql(2)
      ActivePayment::Payone::Gateway.key.should eql("test_key")
    end

    it 'should set by yml' do
      File.open("#{FIXTURES_PATH}/activepayment_config.yml") do |config_file|
        ActivePayment::Payone::Gateway.config = YAML.load(config_file.read)['development']

        ActivePayment::Payone::Gateway.mid.should eql(1)
        ActivePayment::Payone::Gateway.portalid.should eql(2)
        ActivePayment::Payone::Gateway.key.should eql("test_key")
      end
    end
  end

end
