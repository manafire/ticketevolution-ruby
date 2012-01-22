require 'spec_helper'

describe TicketEvolution do
  subject{ TicketEvolution }

  it "should specify a version" do
    subject::VERSION.should be
  end

  describe ".root" do
    subject { TicketEvolution.root }

    it { should be_a Pathname }

    it "should end in 'ticket_evolution'" do
      subject.to_s.should =~ /ticket_evolution$/
    end
  end
end

