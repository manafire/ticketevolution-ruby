require 'spec_helper'

describe TicketEvolution::Client do
  subject { TicketEvolution::Client }

  it_behaves_like "a ticket_evolution model"
end
