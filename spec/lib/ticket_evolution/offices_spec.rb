require 'spec_helper'

describe TicketEvolution::Offices do
  let(:klass) { TicketEvolution::Offices }
  let(:single_klass) { TicketEvolution::Office }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a search endpoint'
  it_behaves_like 'a show endpoint'
end
