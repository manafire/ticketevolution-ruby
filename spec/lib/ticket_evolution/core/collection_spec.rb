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
    its(:status_code) { should == 200 }
    its(:code) { should == 200 }
  end

  context "#each" do
    it "iterates through all the entries" do
      subject.size.should == 2
      subject.each do |entry|
        entry.should be_instance_of TicketEvolution::Brokerage
      end
    end
  end

  describe "#last" do
    it "should pass the request to the @entries array" do
      subject.entries.should_receive(:last)

      subject.last
    end
  end

  describe "#all" do
    it "should alias entries" do
      subject.all.should == subject.entries
    end
  end

  describe "#[]" do
    it "should pass the request to the @entries array" do
      subject.entries.should_receive(:[]).with(1)

      subject[1]
    end
  end
end
