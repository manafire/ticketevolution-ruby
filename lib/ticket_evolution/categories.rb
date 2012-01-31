module TicketEvolution
  class Categories < Endpoint
    include TicketEvolution::Modules::Deleted
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
  end
end
