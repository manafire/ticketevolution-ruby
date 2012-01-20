require "spec_helper"

describe "TicketEvolution::Venue" do
  describe "#find" do
    before(:all) do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
      end
    end

    it "should assemble the correct signature and the correct path to perform the get with" do
      VCR.use_cassette "venue/find_by_id" do
        response = TicketEvolution::Venue.find(896)
        response.class.should           ==  TicketEvolution::Venue
        response.url.should             ==  "/venues/896"
        response.location               ==  "New York, NY"
      end
    end
  end

  # There is an issue with VCR. EVERY time I run the specs again for some reason I get a message that http requests
  # are banned but only AFTER it has been recorded. New Tool To Me , sure what im doing wrong.
  # [DKM 2012.01.15]
  describe "#list" do
    before(:all) do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
      end
    end

    it "should assemble the correct signature and the correct path to perform the get with" do
      VCR.use_cassette "venue/list_by_name" do
        response = TicketEvolution::Venue.list(:name => "Troubadour")
        response.first.class.should == TicketEvolution::Venue
        response.should.class       == Array
        response.first.name.should  == "Troubadour"
        response.first.url.should   == "/venues/1606"
        response.length.should      == 1
      end
    end
  end

  # describe "#find_by_performer" do
  #     before(:all) do
  #       TicketEvolution::configure do |config|
  #         config.token    = "958acdf7da43b57ac93b17ff26eabf45"
  #         config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
  #         config.version  = 8
  #         config.mode     = :sandbox
  #       end
  #     end
  #
  #
  #     it "should return a list of venues" do
  #       initial_events = []
  #       VCR.use_cassette "venue/find_performer_events" do
  #         events_for_performer = TicketEvolution::Event.find_by_performer(1859)
  #         events_for_performer.class.should == Array
  #         events_for_performer.class.first.should == TicketEvolution::Event
  #       end
  #
  #     end
  #   end






end
