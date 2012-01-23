module TicketEvolution
  class Brokerage < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Search
    include TicketEvolution::Show
  end
end
