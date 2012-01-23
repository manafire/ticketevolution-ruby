module TicketEvolution
  class User < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Search
    include TicketEvolution::Show
  end
end
