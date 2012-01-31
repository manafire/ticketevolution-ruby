module TicketEvolution
  class TicketGroups < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
  end
end
