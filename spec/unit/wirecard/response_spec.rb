require "spec_helper"

describe ActivePayment::Wirecard::Response do

  it "should parse response" do
    File.open("#{FIXTURES_PATH}/wirecard/gateway/successful_authorization_response.xml") do |file|
      response = ActivePayment::Wirecard::Response.new(file)
      response.job_id.should eql('test dummy data')
      response['GuWID'].should eql('C822580121385121429927')
    end
  end
end