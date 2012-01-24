require 'spec_helper'

describe TicketEvolution::Performers do
  let(:klass) { TicketEvolution::Performers }
  let(:single_klass) { TicketEvolution::Performer }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a search endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'a deleted endpoint'
end
