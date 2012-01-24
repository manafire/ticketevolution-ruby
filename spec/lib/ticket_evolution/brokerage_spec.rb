require 'spec_helper'

describe TicketEvolution::Brokerage do
  subject { TicketEvolution::Brokerage }

  its(:ancestors) { should include TicketEvolution::Builder }
end
