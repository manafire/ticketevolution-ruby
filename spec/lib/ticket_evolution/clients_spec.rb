require 'spec_helper'

describe TicketEvolution::Clients do
  let(:klass) { TicketEvolution::Clients }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'
end
