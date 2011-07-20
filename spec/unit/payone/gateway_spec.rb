require 'spec_helper'

describe ActivePayment::Payone::Gateway do

  let(:amount) { 100 }
  let(:gateway) { ActivePayment::Payone::Gateway.new(amount) }

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

  it "should build authorization request" do
    gateway.authorization_request.should_not be_blank
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