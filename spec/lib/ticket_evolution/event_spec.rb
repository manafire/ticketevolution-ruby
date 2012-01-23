require 'spec_helper'

describe TicketEvolution::Event do
  let(:klass) { TicketEvolution::Event }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a deleted endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
end
