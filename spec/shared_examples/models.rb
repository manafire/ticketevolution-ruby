require 'spec_helper'

shared_examples_for "a ticket_evolution model" do
  let(:klass) { subject }
  let(:instance) { klass.new({:connection => Fake.connection}) }

  its(:ancestors) { should include TicketEvolution::Model }

  describe "#attributes" do
    it "should return a hash of attribute key/pair values" do
      instance.one = 1
      instance.two = 2
      instance.three = nil

      instance.attributes.should == {"one" => 1, "two" => 2, "three" => nil}
    end

    it "should return a HashWithIndifferentAccess" do
      instance.attributes.should be_a HashWithIndifferentAccess
    end
  end
end
