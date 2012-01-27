require 'spec_helper'

describe TicketEvolution::ConnectionNotFound do
  subject { TicketEvolution::ConnectionNotFound }

  it_behaves_like "a ticket_evolution error class"
end
