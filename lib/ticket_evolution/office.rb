module TicketEvolution
  class Office < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Search
    include TicketEvolution::Show
  end
end
