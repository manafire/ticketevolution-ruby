require 'spec_helper'

describe TicketEvolution::InvalidConfiguration do
  subject { TicketEvolution::InvalidConfiguration }

  it_behaves_like "a ticket_evolution error class"
end

