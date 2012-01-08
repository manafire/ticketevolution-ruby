require "spec_helper"

describe "Ticketevolution::Event" do
  
  describe "#search" do
    before(:all) do
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
    end
    
    it "should return a collection of events when given a query parmeter" do
      VCR.use_cassette "events/search/200" do
        events = Ticketevolution::Event.list({:venue_id => 896})
        events.class.should == Array
      end
    end
  end
  
  
end