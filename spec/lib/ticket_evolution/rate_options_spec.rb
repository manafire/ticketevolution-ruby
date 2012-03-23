describe TicketEvolution::RateOptions do
  let(:klass) { TicketEvolution::RateOptions }
  let(:single_klass) { TicketEvolution::RateOption }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
end
