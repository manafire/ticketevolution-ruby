require 'spec_helper'

describe TicketEvolution::Performer do
  subject { TicketEvolution::Performer }

  its(:ancestors) { should include TicketEvolution::Builder }
end
