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
    
    it "should let me search for performers and return back and array of related performers with one result" do
      VCR.use_cassette "perfomer/search/arrity_test" do
        performer = Ticketevolution::Performer.search("Disco Biscuits")
        performer.class.should             == Array
        performer.length.should            == 1
        performer.first.name.should        == "Disco Biscuits"
        performer.first.url.should         == "/performers/3238"
        performer.first.updated_at.should  == "2011-12-08T05:16:46Z"
      end
    end    
  
  
    it "should return an array of serveral results for a performer search that has many performers" do
      VCR.use_cassette "base/handle_pagination_test" do
        performers = Ticketevolution::Performer.search("Dave")
        performers.class.should                                            == Array
        performers.first.name.should                                       == "Dave Gahan"
        performers.first.url.should                                        == "/performers/2892"
        performers.length.should                                           == 45
        performers.all? {|p| p.class == Ticketevolution::Performer}.should == true
      end
    end
  end
  
  describe "#handle_pagination!" do
    before(:each) do
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
    end
    
    it "setup the current page, the total pages with some math , the total entries and the per_page and on the base class!" do
      VCR.use_cassette "base/handle_pagination_test" do
        performers = Ticketevolution::Performer.search("Dave")
        Ticketevolution::Performer.total_pages.should   == 1
        Ticketevolution::Performer.per_page.should      == 100
        Ticketevolution::Performer.total_entries.should == 45
      end
    end
      
    it "the collection singleton attribute should hold onto the currnet objects that came back from a search" do
      VCR.use_cassette "base/handle_pagination_test" do
        performers = Ticketevolution::Performer.search("Dave")
        Ticketevolution::Performer.collection.length.should == performers.length
        Ticketevolution::Performer.collection.first.class   == performers.first.class
        Ticketevolution::Performer.collection.first.name    == Array
        Ticketevolution::Performer.collection.first.url     == Array
        Ticketevolution::Base.collection.should_not         == performers
      end
    end
    
    it "should with calling events on a performer supply ther performer_id parameter to the list call on events" do
      
    end
    
    
    it "should return event objects in an array when a performer object is instantiated" do
      VCR.use_cassette "performer/event_delegation_test" do
        performer    = Ticketevolution::Performer.search("Phish").last
        performer.class.should               == Ticketevolution::Performer
        performer.name.should                == "Phish"
        phish_events = []
        VCR.use_cassette  "events/performer.event_delegation_test" do
          phish_events = performer.events
        end
        phish_events.class.should            == Array
        phish_events.last.class.should       == Ticketevolution::Event  
        phish_events.length.should           == 100
        phish_events.last.name.should == "Rock of Ages - San Diego"
      end 
    end
    
  end

end