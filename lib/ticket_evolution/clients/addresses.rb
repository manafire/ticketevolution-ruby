module TicketEvolution
  class Clients
    class Addresses < TicketEvolution::Endpoint
      include TicketEvolution::Modules::Create
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show
      include TicketEvolution::Modules::Update
    end
  end
end
