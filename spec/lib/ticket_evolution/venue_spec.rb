require 'spec_helper'

describe TicketEvolution::Venue do
  subject { TicketEvolution::Venue }

  its(:ancestors) { should include TicketEvolution::Builder }
end
