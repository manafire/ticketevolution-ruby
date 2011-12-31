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
    end

    it "should return the respective performer with the find call" do
      VCR.use_cassette "perfomer/find/200" do
        path = "#{@http_base}.ticketevolution.com/performers/9?"
        performer = Ticketevolution::Performer.find(3219)      
        performer.name.should == ("Dipset")
        performer.updated_at.should == ("2011-02-05T09:49:26Z")
        performer.category.should == (nil)
        performer.venue.should == (nil)
        performer.upcoming_events.should == ({"last"=>nil, "first"=>nil})
      end
    end
    
    it "should return the respective performer with the show call as it is what the find call is aliased too" do
      VCR.use_cassette "perfomer/show/200" do
        path = "#{@http_base}.ticketevolution.com/performers/9?"
        performer = Ticketevolution::Performer.show(3219)      
        performer.name.should == ("Dipset")
        performer.updated_at.should == ("2011-02-05T09:49:26Z")
        performer.category.should == (nil)
        performer.venue.should == (nil)
        performer.upcoming_events.should == ({"last"=>nil, "first"=>nil})
      end
    end
  end
  
  # NON FUNCTIONAL AS OF 2011.12.31 SEE 
  # CURRENTLY RETURNS 
  # {:server_message=>"The requested resource could not be located.", :errors=>nil, :body=>{"message"=>"Couldn't find Performer with ID=17392", "error"=>"Not Found"}, :response_code=>"HTTP/1.1 404 Not Found\r\nContent-Type: application/vnd.ticketevolution.api+json; version=8; charset=utf-8\r\nTransfer-Encoding: chunked\r\nConnection: keep-alive\r\nStatus: 404\r\nX-Powered-By: Phusion Passenger (mod_rails/mod_rack) 2.2.10\r\nX-UA-Compatible: IE=Edge,chrome=1\r\nX-Runtime: 0.199616\r\nCache-Control: no-cache\r\nStrict-Transport-Security: max-age=31536000\r\nServer: nginx/0.7.65 + Phusion Passenger 2.2.10 (mod_rails/mod_rack)\r\n\r\n"}      
  #
  # describe "#search" do
  #   before(:each) do
  #     Ticketevolution::configure do |config|
  #       config.token    = "958acdf7da43b57ac93b17ff26eabf45"
  #       config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
  #       config.version  = 8
  #       config.mode     = :sandbox  
  #       config.protocol = :https
  #     end
  #     @http_base = "#{Ticketevolution.protocol}://#{Ticketevolution.mode}"      
  #   end
  #   
  #   it "should let me search for performers and return back and array of related performers" do
  # 
  #     performer = Ticketevolution::Performer.search("Trey")
  #     performer.class.should == Array
  #   end    
  # end

  

end