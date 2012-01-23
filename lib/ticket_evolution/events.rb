module TicketEvolution
  class Events < Endpoint
    include TicketEvolution::Deleted
    include TicketEvolution::List
    include TicketEvolution::Show
  end
end
