require 'spec_helper'

describe TicketEvolution::Clients::Addresses do
  let(:klass) { TicketEvolution::Clients::Addresses }
  let(:single_klass) { TicketEvolution::Address }
  let(:update_base) { {'url' => '/clients/1/addresses/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'
end
