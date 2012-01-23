module TicketEvolution
  class Categories < Endpoint
    include TicketEvolution::Deleted
    include TicketEvolution::List
    include TicketEvolution::Show
  end
end
