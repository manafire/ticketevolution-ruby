require 'spec_helper'

describe TicketEvolution::Base do
  let(:klass) { TicketEvolution::Base }
  let(:sample_klass) { TicketEvolution::Samples }
  let(:base) { klass.new }

  describe "#method_missing" do
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
        message = "undefined method `config' for #{base.inspect}"
        expect { base.config }.to raise_error NoMethodError, message
      end
    end
  end
end
