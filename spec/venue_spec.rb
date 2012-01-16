require "spec_helper"

describe "TicketEvolution::Venue" do
  before(:all) do
    TicketEvolution::configure do |config|
      config.token    = "958acdf7da43b57ac93b17ff26eabf45"
      config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
      config.version  = 8
      config.mode     = :sandbox
    end
  end
  
  describe "#find" do
    it "should assemble the correct signature and the correct path to perform the get with" do
      VCR.use_cassette "venue_find_by_id" do
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
    it "should assemble the correct signature and the correct path to perform the get with" do
      VCR.use_cassette "venue_list_by_name" do
        response = TicketEvolution::Venue.list(:name => "Madison Square Garden")
        response.first.class.should == TicketEvolution::Venue
        response.should.class       == Array
        response.first.name.should  == "Madison Square Garden"
        response.first.url.should   == "/venues/896"
        response.length.should      == 1
      end
    end        
  end
  
  
  
  
  
  
  
end