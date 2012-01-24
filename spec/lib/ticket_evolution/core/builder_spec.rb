require 'spec_helper'

describe TicketEvolution::Builder do
  let(:klass) { TicketEvolution::Builder }
  let(:instance) { klass.new(params) }
  let(:params) { {} }

  subject { klass }

  its(:ancestors) { should include OpenStruct }

  describe "#initialize" do
    let(:params) do
      {
        "url" => "/brokerages/2",
        "natb_member" => true,
        "name" => "Golden Tickets",
        "id" => "2",
        "abbreviation" => "Golden Tickets"
      }
    end

    it "should assign each key value pair as attributes" do
      params.keys.each do |key|
        instance.send(key).should == params[key]
      end
    end

    it "should call #process_datum for each attribute assigned" do
      params.values.each do |v|
        klass.any_instance.should_receive(:process_datum).with(v)
      end
      instance
    end
  end

  describe "#process_datum" do
    let(:time) { "2011-12-18T17:30:06Z" }

    it "should convert any time strings into Time objects" do
      instance.send(:process_datum, time).should == TicketEvolution::Time.parse(time)
    end

    it "should convert hashed into TicketEvolution::Data objects" do
      instance.send(:process_datum, {:one => 1}).should be_a TicketEvolution::Datum
    end
  end

  describe "#method_missing" do
    let(:params) { {} }

    it "should invoke #process_datum with the information received" do
      instance.should_receive(:process_datum).with(:ing)
      instance.test = :ing
      instance.should_receive(:process_datum).with([1,2])
      instance.array = [1,2]
    end
  end
end
