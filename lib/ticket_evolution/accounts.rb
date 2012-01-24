module TicketEvolution
  class Accounts < Endpoint
    include TicketEvolution::List
    include TicketEvolution::Show
  end
end
