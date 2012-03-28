require 'spec_helper'

describe TicketEvolution::TrackDetails do
  let(:klass) { TicketEvolution::TrackDetails }
  let(:single_klass) { TicketEvolution::TrackDetail }

  it_behaves_like 'a show endpoint'

  it "should have a base path of /ticket_groups" do
    klass.new({:parent => Fake.connection}).base_path.should == '/track_details'
  end

  context "integration" do
    use_vcr_cassette "endpoints/track_details/show", :record => :new_episodes

    it "gets tracking details for a FedEx package" do
      details = connection.track_details.find("793309874808")
      details.duplicate_waybill.should == false

      package = details.packages.first
      package.unique_identifier.should == "2455994000~793309874808"
      package.destination_city.should == "NEW YORK"
      package.destination_country.should == "US"
      package.events.length.should == 12
    end

    xit "gets tracking details of a FedEx unique identifier" do
      raise "not implemented"
    end
  end
end

