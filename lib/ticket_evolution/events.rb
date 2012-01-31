module TicketEvolution
  class Events < Endpoint
    include TicketEvolution::Modules::Deleted
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
  end
end
