module TicketEvolution
  class Client < Endpoint
    include TicketEvolution::Create
    include TicketEvolution::List
    include TicketEvolution::Show
    include TicketEvolution::Update
  end
end
