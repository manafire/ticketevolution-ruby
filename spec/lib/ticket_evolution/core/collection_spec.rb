require 'spec_helper'

describe TicketEvolution::Collection do
  subject { TicketEvolution::Collection.build_from_response(response, 'brokerages', TicketEvolution::Brokerage) }
  let(:response) { Fake.list_response }

  context "#build_from_response" do
    it { should be_instance_of(TicketEvolution::Collection) }
    it { should be_kind_of(Enumerable) }
    its(:per_page) { should == 2 }
    its(:total_entries) { should == 1379 }
    its(:current_page) { should == 1 }
  end

  context "#each" do
    it "iterates through all the entries" do
      subject.size.should == 2
      subject.each do |entry|
        entry.should be_instance_of TicketEvolution::Brokerage
      end
    end
  end
end
