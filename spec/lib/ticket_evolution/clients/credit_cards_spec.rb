require 'spec_helper'

describe TicketEvolution::Clients::CreditCards do
  let(:klass) { TicketEvolution::Clients::CreditCards }
  let(:single_klass) { TicketEvolution::CreditCard }
  let(:update_base) { {'url' => '/clients/1/credit_cards/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
end
