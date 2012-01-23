module TicketEvolution
  class Clients < Endpoint
    include TicketEvolution::Create
    include TicketEvolution::List
    include TicketEvolution::Show
    include TicketEvolution::Update
  end
end
