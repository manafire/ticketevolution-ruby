module TicketEvolution
  class Quotes < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Search
    include TicketEvolution::Show
  end
end
