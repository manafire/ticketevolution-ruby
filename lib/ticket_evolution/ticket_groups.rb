module TicketEvolution
  class TicketGroups < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Show
  end
end
