module TicketEvolution
  class Performers < Endpoint
    include TicketEvolution::Deleted
    include TicketEvolution::List
    include TicketEvolution::Search
    include TicketEvolution::Show
  end
end
