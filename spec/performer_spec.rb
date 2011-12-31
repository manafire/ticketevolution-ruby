require "spec_helper"

describe "Ticketevolution::Perfomer" do

  
  describe "#find" do
    before(:each) do
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
      
      @http_base = "#{Ticketevolution.protocol}://#{Ticketevolution.mode}"
    end
      
   
    it "should wih JSON for the respectiveb object through the find call" do
      VCR.use_cassette "perfomer/#find/200" do
        path = "#{@http_base}.ticketevolution.com/performers/9?"
        performer = Ticketevolution::Performer.find(3219)      
        performer.name.should == ("Dipset")
        performer.updated_at.should == ("2011-02-05T09:49:26Z")
        performer.category.should == (nil)
        performer.venue.should == (nil)
        performer.upcoming_events.should == ({"last"=>nil, "first"=>nil})
      end

    end
  end
  


end