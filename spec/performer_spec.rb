require "spec_helper"

describe "TicketEvolution::Perfomer" do
  
  describe "#find" do
    before(:all) do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
    end

    it "should assemble the correct signature and the correct path to perform the get with" do
      VCR.use_cassette "performer/find/regular_find" do
        response = TicketEvolution::Performer.find(90)
        response.class.should           ==  TicketEvolution::Performer
        response.url.should             ==  "/performers/90"
        response.upcoming_events.should == {"last"=>nil, "first"=>nil}
        response.updated_at.should      == "2011-02-05T09:27:07Z"
      end
    end
    
    it "should return the respective performer with the find call" do
      VCR.use_cassette "performer/find/normal_call" do  
        performer = TicketEvolution::Performer.find(3219)      
        performer.name.should            == ("Dipset")
        performer.updated_at.should      == ("2011-02-05T09:49:26Z")
        performer.category.should        == (nil)
        performer.venue.should           == (nil)
        performer.upcoming_events.should == ({"last"=>nil, "first"=>nil})
      end
      end
      
    it "should return the respective performer with the show call as it is what the find call is aliased too" do
      VCR.use_cassette "performer_show_call_success" do
        path = "#{@http_base}.TicketEvolution.com/performers/9"
        performer = TicketEvolution::Performer.show(3219)      
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
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox  
        config.protocol = :https
      end
      @http_base = "#{TicketEvolution.protocol}://#{TicketEvolution.mode}"      
    end
    
    it "should let me search for performers and return back and array of related performers with one result" do
      VCR.use_cassette "performer/search/arrity_test" do
        performer = TicketEvolution::Performer.search("Disco Biscuits")
        performer.class.should             == Array
        performer.length.should            == 1
        performer.first.name.should        == "Disco Biscuits"
        performer.first.url.should         == "/performers/3238"
        performer.first.updated_at.should  == "2011-12-08T05:16:46Z"
      end
    end    
  
    it "should return event objects in an array when a performer object is instantiated" do
      VCR.use_cassette "event_delegate_phish_second" do
        performer    = TicketEvolution::Performer.search("Phish").last
        performer.class.should               == TicketEvolution::Performer
        performer.name.should                == "Phish"
      end 
    end
    

    it "should allow for assocation proxy calls" do
      VCR.use_cassette "spec_that_causes_trouble" do
        # Perhaps A FACTORY>?
        response = {}
        response[:body]           = {:name => "Phish", :id => 8859}
        response[:response_code]  = nil
        response[:errors]         = nil
        response[:server_message] = nil
    
        phish = TicketEvolution::Performer.new(response)
        phish.events.should == "Zero TicketEvolution::Event Items Were Found"
      end
    end

  
    it "should return an array of serveral results for a performer search that has many performers" do
      VCR.use_cassette "base_handle_pagination_test_first" do
        performers = TicketEvolution::Performer.search("Dave")
        performers.class.should                                            == Array
        performers.first.name.should                                       == "Dave Gahan"
        performers.first.url.should                                        == "/performers/2892"
        performers.length.should                                           == 45
        performers.all? {|p| p.class == TicketEvolution::Performer}.should == true
      end
    end
  end
  
  describe "#handle_pagination!" do
    before(:each) do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
    end
    
    it "setup the current page, the total pages with some math , the total entries and the per_page and on the base class!" do
      VCR.use_cassette "base_handle_pagination_test_second" do
        performers = TicketEvolution::Performer.search("Dave")
        TicketEvolution::Performer.total_pages.should   == 1
        TicketEvolution::Performer.per_page.should      == 100
        TicketEvolution::Performer.total_entries.should == 45
      end
    end
      
    it "the collection singleton attribute should hold onto the currnet objects that came back from a search" do
      VCR.use_cassette "base_handle_pagination_test_third" do
        performers = TicketEvolution::Performer.search("Dave")
        TicketEvolution::Performer.collection.length.should == performers.length
        TicketEvolution::Performer.collection.first.class   == performers.first.class
        TicketEvolution::Performer.collection.first.name    == Array
        TicketEvolution::Performer.collection.first.url     == Array
        TicketEvolution::Base.collection.should_not         == performers
      end
    end
  end
  

  
end