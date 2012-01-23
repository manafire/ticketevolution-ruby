module TicketEvolution
  class Offices < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Search
    include TicketEvolution::Show
  end
end
