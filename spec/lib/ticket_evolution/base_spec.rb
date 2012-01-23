require 'spec_helper'

describe TicketEvolution::Base do
  let(:klass) { TicketEvolution::Base }
  let(:sample_klass) { TicketEvolution::Samples }
  let(:base) { klass.new }

  describe "#method_missing" do
    it "should attempt to find a class which matches the missing method" do
      TicketEvolution.should_receive(:const_defined?).with(:NoObjects)
      expect { base.no_objects }.to raise_error
    end

    context "when the missing class is found" do
      it "should instantiate a new instance of the class, passing itself to initialize as :parent" do
        instance = sample_klass.new({:parent => base})
        sample_klass.should_receive(:new).with({:parent => base}).and_return(instance)
        base.samples.should be_a sample_klass
      end
    end

    context "when the missing class is not found" do
      it "should perform as if the method doesn't exist" do
        message = "undefined method `coconuts' for #{base.inspect}"
        expect { base.coconuts }.to raise_error NoMethodError, message
      end
    end
  end
end
