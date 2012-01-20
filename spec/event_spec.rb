require "spec_helper"

describe "TicketEvolution::Event" do
  before { setup_config }

  describe "#search" do
    it "should return a collection of events when given a query parmeter" do
      VCR.use_cassette "event/search/200" do
        events = TicketEvolution::Event.list({:venue_id => 896})
        events.class.should == Array
      end
    end
  end

  describe "#find_by_venue" do
    it "should return all events only scoped to the venue object that find_by_venue is being called from" do
      venues = []
      VCR.use_cassette "venue/for_find_by_venue/msg" do
        venues = TicketEvolution::Venue.search("Madison Square Garden")
        venues.first.name = "Madison Sqare Garden"
        msg_id = venues.first.id
      end
      msg = venues.first

      events_at_msg = []
      VCR.use_cassette "event/find_by_venue_with_msg" do
        events_at_msg = msg.events
      end

      events_at_msg.class == Array
      events_at_msg.all? {|e| e.venue == {"name"=>"Madison Square Garden", "location"=>"New York, NY", "url"=>"/venues/896", "id"=>"896"} }
    end
  end
end
