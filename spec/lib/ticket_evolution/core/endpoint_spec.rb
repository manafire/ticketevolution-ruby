require 'spec_helper'

describe TicketEvolution::Endpoint do
  let(:klass) { TicketEvolution::Endpoint }
  let(:single_klass) { TicketEvolution::Endpoint }

  subject { klass }

  its(:ancestors) { should include TicketEvolution::Base }

  it_behaves_like "a ticket_evolution endpoint class"
end
