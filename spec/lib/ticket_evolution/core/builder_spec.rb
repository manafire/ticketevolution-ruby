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

    context "when dealing with a string" do
      context "formatted as time" do
        it "should convert the string to a TicketEvolution::Time object" do
          instance.send(:process_datum, time).should == TicketEvolution::Time.parse(time)
        end
      end
    end

    context "when dealing with a hash" do
      context "which has a :url key" do
        let(:hash) do
          {
            "url" => "/brokerages/227",
            "name" => "Night To Remember Tickets",
            "id" => "227",
            "abbreviation" => "Night to Remember"
          }
        end

        it "should create an appropriate builder object" do
          instance.send(:process_datum, hash).should be_a TicketEvolution::Brokerage
        end
      end

      context "which does not have a :url key" do
        it "should instantiate a new TicketEvolution::Datum object" do
          instance.send(:process_datum, {:one => 1}).should be_a TicketEvolution::Datum
        end
      end
    end

    context "when dealing with an array" do
      it "should map arrays, calling itself on each value" do
        instance.send(:process_datum, [{:one => 1}, time]).should == [
          TicketEvolution::Datum.new({:one => 1}),
          TicketEvolution::Time.parse(time)
        ]
      end
    end
  end

  describe "#class_name_from_url" do
    it "extracts a TicketEvolution class name from a url, searching segments right to left" do
      {
        '/events' => 'TicketEvolution::Events',
        '/events/12' => 'TicketEvolution::Events',
        '/events/deleted' => 'TicketEvolution::Events',
        '/events/21/venues/12' => 'TicketEvolution::Venues'
      }.each do |given, expected|
        instance.send(:class_name_from_url, given).should == expected
      end
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
