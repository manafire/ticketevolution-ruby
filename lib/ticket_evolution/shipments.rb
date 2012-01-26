module TicketEvolution
  class Shipments < Endpoint
    include TicketEvolution::Create
    include TicketEvolution::List
    include TicketEvolution::Show
    include TicketEvolution::Update
  end
end
