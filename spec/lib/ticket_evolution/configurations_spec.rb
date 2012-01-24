require 'spec_helper'

describe TicketEvolution::Configurations do
  let(:klass) { TicketEvolution::Configurations }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
end
