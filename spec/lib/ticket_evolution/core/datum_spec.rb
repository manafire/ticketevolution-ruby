require 'spec_helper'

describe TicketEvolution::Datum do
  let(:klass) { TicketEvolution::Datum }
  let(:instance) { klass.new }

  subject { klass }

  its(:ancestors) { should include TicketEvolution::Builder }

  it "should respond to []" do
    instance.test = :testing
    instance[:test].should == :testing
  end
end
