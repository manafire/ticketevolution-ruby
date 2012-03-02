require 'spec_helper'

describe TicketEvolution::Companies do
  let(:klass) { TicketEvolution::Companies }
  let(:single_klass) { TicketEvolution::Company }
  let(:update_base) { {} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a destroy endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'
end

