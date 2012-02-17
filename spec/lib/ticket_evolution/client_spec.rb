require 'spec_helper'

describe TicketEvolution::Client do
  let(:klass) { TicketEvolution::Client }
  subject { TicketEvolution::Client }

  describe "when calling a nested endpoint method" do
    use_vcr_cassette "endpoints/clients", :record => :new_episodes

    let(:client) { TicketEvolution::Clients.new(:parent => connection).list.last }

    it "should pass the request to the appropriate endpoint and get back an appropriate response" do
      collection = client.addresses.list
      collection.should be_a TicketEvolution::Collection
      collection.total_entries.should == collection.size
      collection.first.should be_a TicketEvolution::Address
    end
  end

  it_behaves_like "a ticket_evolution model"
end
