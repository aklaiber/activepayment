require "spec_helper"

describe ActivePayment::Payone::Response do

  it "should get params by []" do
    File.open("#{FIXTURES_PATH}/payone/gateway/successful_authorization_response.txt") do |file|
      response = ActivePayment::Payone::Response.new(file.read)
      response[:status].should eql('APPROVED')
    end
  end

  it "should get params by method" do
    File.open("#{FIXTURES_PATH}/payone/gateway/successful_authorization_response.txt") do |file|
      response = ActivePayment::Payone::Response.new(file.read)
      response.status.should eql('APPROVED')
      response.successful?.should be_true
      response.failed?.should be_false
    end
  end

end