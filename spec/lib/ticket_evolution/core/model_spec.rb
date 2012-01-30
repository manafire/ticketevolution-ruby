require 'spec_helper'

describe TicketEvolution::Model do
  let(:klass) { TicketEvolution::Model }
  let(:sample_klass) { TicketEvolution::Models::Samples }
  let(:instance) { klass.new({:id => 1, :connection => connection}) }
  let(:connection) { Fake.connection }

  subject { klass }

  its(:ancestors) { should include TicketEvolution::Builder }

  describe "#initialize" do
    context "when it receives an instance of connection" do
      subject { klass.new({:connection => connection}) }

      it "should not error" do
        expect { subject }.to_not raise_error
      end

      it "should not respond to #connection" do
        subject.should_not respond_to :connection
      end
    end

    context "when it does not receive an instance of connection" do
      it "should raise a ConnectionNotFound error" do
        message = "#{klass.name} must receive a TicketEvolution::Connection object on initialize"
        expect { klass.new }.to raise_error TicketEvolution::ConnectionNotFound, message
      end
    end
  end

  describe "#process_datum" do
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
          instance.instance_eval { @connection = Fake.connection }
          instance.send(:process_datum, hash).should be_a TicketEvolution::Brokerage
        end
      end

      context "which does not have a :url key" do
        it "should instantiate a new TicketEvolution::Datum object" do
          instance.send(:process_datum, {:one => 1}).should be_a TicketEvolution::Datum
        end
      end
    end
  end

  describe "#plural_class_name" do
    it "should return the pluralized version of the current class" do
      instance.plural_class_name.should == "TicketEvolution::#{klass.name.demodulize.pluralize.camelize}"
    end
  end

  describe "#plural_class" do
    let(:plural_class_name) { "TicketEvolution::Models" }
    it "call #constantize on the result of #plural_class_name" do
      instance.should_receive(:plural_class_name).and_return(plural_class_name)
      plural_class_name.should_receive(:constantize)
      instance.plural_class
    end
  end

  describe "#method_missing" do
    it "should attempt to find a class which matches the missing method, scoped to it's plural namespace" do
      instance.plural_class.should_receive(:const_defined?).with(:NoObjects)
      expect { instance.no_objects }.to raise_error
    end

    context "when the missing class is found" do
      before { @endpoint = instance.plural_class.new({:id => instance.id, :parent => connection}) }

      it "should instantiate a new instance of the requested endpoint, passing a new instance of it's endpoint class as parent" do
        instance.plural_class.should_receive(:new).with({
          :connection => connection,
          :id => instance.id
        }).and_return(@endpoint)
        sample_klass.should_receive(:new).with({:parent => @endpoint})

        instance.samples
      end
    end

    context "when the missing class is not found" do
      it "should perform as if the method doesn't exist" do
        message = "undefined method `coconuts' for #{instance.inspect}"
        expect { instance.coconuts }.to raise_error NoMethodError, message
      end
    end
  end
end
