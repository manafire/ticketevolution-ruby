module TicketEvolution
  class Shipments < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Create
    include TicketEvolution::Show
    include TicketEvolution::Update
  end
end
