require "spec_helper"

describe ActivePayment::Response do

  it "should parse response" do
    File.open("#{FIXTURES_PATH}/gateways/wirecard/successful_authorization_response.xml") do |file|
      response = ActivePayment::Response.new(file)
      response.job_id.should eql('test dummy data')
      response['GuWID'].should eql('C822580121385121429927')
    end
  end
end