require 'spec_helper'

describe TicketEvolution::Model do
  let(:klass) { TicketEvolution::Model }

  subject { klass }

  its(:ancestors) { should include TicketEvolution::Builder }

  describe "#plural_class_name" do
    let(:instance) { klass.new }

    it "should return the pluralized version of the current class" do
      instance.plural_class_name.should == "TicketEvolution::#{klass.name.demodulize.pluralize.camelize}"
    end
  end
end
