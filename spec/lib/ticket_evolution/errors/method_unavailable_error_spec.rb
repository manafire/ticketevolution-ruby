require 'spec_helper'

describe TicketEvolution::MethodUnavailableError do
  subject { TicketEvolution::MethodUnavailableError }

  it_behaves_like "a ticket_evolution error class"
end
