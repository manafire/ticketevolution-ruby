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

    context "when it detects a scope in the url" do
      let(:instance) { klass.new({:connection => connection, 'url' => '/clients/2/addresses/1'}) }
      let(:scope) { '/clients/2' }

      it "should set @scope" do
        instance.instance_eval{ @scope }.should == scope
      end
    end

    context "when it does not detect a scope in the url" do
      it "should not error" do
        expect { klass.new({:connection => connection}) }.to_not raise_error
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
    let(:plural_name) { klass.name.demodulize.pluralize.camelize }
    context "when there is a scope" do
      before { instance.instance_eval{ @scope = '/events/1' } }

      it "should include the scoped endpoint name in the pluralized version of the current class" do
        instance.plural_class_name.should == "TicketEvolution::Events::#{plural_name}"
      end
    end

    context "when there is not a scope" do
      it "should return the pluralized version of the current class" do
        instance.plural_class_name.should == "TicketEvolution::#{plural_name}"
      end
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

  describe "#scope" do
    context "when @scope is set" do
      before { instance.instance_eval{ @scope = '/events/1' } }
      let(:scope_hash) { { :class => "TicketEvolution::Events", :id => 1 } }

      it "should return and array with class and id specified" do
        instance.scope.should == scope_hash
      end
    end

    context "when @scope is not set" do
      it "should return nil" do
        instance.scope.should == nil
      end
    end
  end

  describe "#attributes" do
    let(:params) { {"one" => 1, "two" => 2} }
    let(:expected) { HashWithIndifferentAccess.new(params) }

    it "should return the set attributes" do
      klass.new(params.merge(:connection => connection)).attributes.should == expected
    end
  end

  describe "#attributes=" do
    let(:initial) { {"one" => :one, "three" => 3} }
    let(:params) { {"one" => 1, "two" => 2} }
    let(:expected) { HashWithIndifferentAccess.new(initial.merge(params)) }

    it "should set the passed attributes" do
      instance = klass.new(initial.merge(:connection => connection))
      instance.attributes = params
      instance.attributes.should == expected
    end
  end

  describe "#method_missing" do
    context "when the missing class is not found" do
      it "should fall back on the default functionality" do
        expect { instance.no_objects }.to_not raise_error
      end
    end

    context "when the missing class is found" do
      before { @endpoint = instance.plural_class.new({:id => instance.id, :parent => connection}) }

      it "should instantiate a new instance of the requested endpoint, passing a new instance of it's endpoint class as parent" do
        instance.plural_class.should_receive(:new).with({
          :parent => connection,
          :id => instance.id
        }).and_return(@endpoint)
        sample_klass.should_receive(:new).with({:parent => @endpoint})

        instance.samples
      end
    end
  end
end
