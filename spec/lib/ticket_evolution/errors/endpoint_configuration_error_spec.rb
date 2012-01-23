require 'spec_helper'

describe TicketEvolution::EndpointConfigurationError do
  subject { TicketEvolution::EndpointConfigurationError }

  it_behaves_like "a ticket_evolution error class"
end

