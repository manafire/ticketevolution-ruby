module TicketEvolution
  class Event < Endpoint
    include TicketEvolution::Deleted
    include TicketEvolution::List
    include TicketEvolution::Show
  end
end
