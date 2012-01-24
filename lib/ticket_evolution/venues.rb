module TicketEvolution
  class Venues < Endpoint
    include TicketEvolution::Deleted
    include TicketEvolution::List
    include TicketEvolution::Search
    include TicketEvolution::Show
  end
end
