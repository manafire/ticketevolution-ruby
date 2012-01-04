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
        performer.name.should            == ("Dipset")
        performer.updated_at.should      == ("2011-02-05T09:49:26Z")
        performer.category.should        == (nil)
        performer.venue.should           == (nil)
        performer.upcoming_events.should == ({"last"=>nil, "first"=>nil})
      end
    end
    
    it "should return the respective performer with the show call as it is what the find call is aliased too" do
      VCR.use_cassette "perfomer/show/200" do
        path = "#{@http_base}.ticketevolution.com/performers/9?"
        performer = Ticketevolution::Performer.show(3219)      
        performer.name.should            == ("Dipset")
        performer.updated_at.should      == ("2011-02-05T09:49:26Z")
        performer.category.should        == (nil)
        performer.venue.should           == (nil)
        performer.upcoming_events.should == ({"last"=>nil, "first"=>nil})
      end
    end
  end

  describe "#search" do
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
    
    it "should let me search for performers and return back and array of related performers" do
      VCR.use_cassette "perfomer/search/arrity_test" do
        performer = Ticketevolution::Performer.search("Disco Biscuits")
        performer.class.should             == Array
        performer.length.should            == 1
        performer.first.name.should        == "Disco Biscuits"
        performer.first.url.should         == "/performers/3238"
        performer.first.updated_at.should  == "2011-12-08T05:16:46Z"

      end
    end    
  end  
  #   # it "should let me search for performers and return back and array of related performers" do
  #   #   VCR.use_cassette "perfomer/search/singularity_test" do
  #   #     performer = Ticketevolution::Performer.search("Phish")
  #   #     performer.class.should == Array
  # end

  

end