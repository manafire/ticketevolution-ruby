require 'spec_helper'

describe TicketEvolution::Brokerages do
  let(:klass) { TicketEvolution::Brokerages }
  let(:single_klass) { TicketEvolution::Brokerage }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a search endpoint'
  it_behaves_like 'a show endpoint'

  context "integration tests" do
    use_vcr_cassette "endpoints/brokerages", :record => :new_episodes

    it "returns a brokerage" do
      brokerage = connection.brokerages.show(2)

      brokerage.should be_a TicketEvolution::Brokerage
      brokerage.name.should == "Golden Tickets"
      brokerage.id.should == "2"
      brokerage.url.should == "/brokerages/2"
    end

    it "returns a list of brokerages" do
      brokerages = connection.brokerages.list(:per_page => 3, :page => 4)

      brokerages.per_page.should == 3
      brokerages.current_page.should == 4
      brokerages.total_entries.should == 1379

      brokerages.size.should == 3
      brokerages.each do |brokerage|
        brokerage.should be_a TicketEvolution::Brokerage
      end
    end
  end

end
