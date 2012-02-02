require 'spec_helper'

describe TicketEvolution::Clients::EmailAddresses do
  let(:klass) { TicketEvolution::Clients::EmailAddresses }
  let(:single_klass) { TicketEvolution::EmailAddress }
  let(:update_base) { {'url' => '/clients/1/email_addresses/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'
end
