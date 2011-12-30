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

      cassette = YAML.load(File.open('spec/webmocks/performers_get_200.yml'))
      stub_request(:get, "https://api.sandbox.ticketevolution.com/performers/9?").with(:headers => {'Accept'=>'application/vnd.ticketevolution.api+json; version=8', 'X-Signature'=>'HtLlrlGmNWMEyRPdSCaRvnW3+YB1WnvMJ6q4/liCr9A=', 'X-Token'=>'958acdf7da43b57ac93b17ff26eabf45'}).to_return(:status => 200, :body => cassette["body_str"], :headers => cassette["header_str"])
      path = "#{@http_base}.ticketevolution.com/performers/9?"
      performer = Ticketevolution::Performer.find(9)
      
      performer.name.should == ("Dipset")
      performer.updated_at.should == ("2011-02-05T09:49:26Z")
      performer.category.should == (nil)
      performer.venue.should == (nil)
      performer.upcoming_events.should == ({"last"=>nil, "first"=>nil})
      

    end
  end
  


end