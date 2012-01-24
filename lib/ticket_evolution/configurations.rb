module TicketEvolution
  class Configurations < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Show
  end
end
