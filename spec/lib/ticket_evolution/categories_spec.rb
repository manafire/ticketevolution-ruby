require 'spec_helper'

describe TicketEvolution::Categories do
  let(:klass) { TicketEvolution::Categories }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a deleted endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
end
