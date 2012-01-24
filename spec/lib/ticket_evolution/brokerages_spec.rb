require 'spec_helper'

describe TicketEvolution::Brokerages do
  let(:klass) { TicketEvolution::Brokerages }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a search endpoint'
  it_behaves_like 'a show endpoint'

  context "integration tests" do
    use_vcr_cassette "endpoints/brokerages/show", :record => :new_episodes

    it "returns a single klass object" do
      brokerage = connection.brokerages.show(2)

      brokerage.should be_a TicketEvolution::Brokerage
      brokerage.name.should == "Golden Tickets"
      brokerage.id.should == "2"
      brokerage.url.should == "/brokerages/2"
    end
  end

end
