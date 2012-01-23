module TicketEvolution
  class Category < Endpoint
    include TicketEvolution::Deleted
    include TicketEvolution::List
    include TicketEvolution::Show
  end
end
