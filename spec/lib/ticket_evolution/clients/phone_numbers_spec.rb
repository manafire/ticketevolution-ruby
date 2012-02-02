require 'spec_helper'

describe TicketEvolution::Clients::PhoneNumbers do
  let(:klass) { TicketEvolution::Clients::PhoneNumbers }
  let(:single_klass) { TicketEvolution::PhoneNumber }
  let(:update_base) { {'url' => '/clients/1/phone_numbers/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'
end
