require 'spec_helper'

describe TicketEvolution::Search do
  let(:klass) { TicketEvolution::Search }
  let(:single_klass) { TicketEvolution::Search }

  it_behaves_like 'a ticket_evolution endpoint class'

  context "integration tests" do
    use_vcr_cassette "endpoints/search", :record => :new_episodes

    it "returns a list of results" do
      search_results = connection.search.list(:q => "play", :per_page => 5, :page => 1)

      search_results.per_page.should == 5
      search_results.current_page.should == 1
      search_results.each do |result|
        result.should be_a TicketEvolution::Model
      end
    end
  end
end
