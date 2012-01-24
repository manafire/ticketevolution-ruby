require 'spec_helper'

describe TicketEvolution::Shipments do
  let(:klass) { TicketEvolution::Shipments }
  let(:single_klass) { TicketEvolution::Shipment }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'an update endpoint'
  it_behaves_like 'a show endpoint'
end
