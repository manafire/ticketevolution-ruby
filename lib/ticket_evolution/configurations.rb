module TicketEvolution
  class Configurations < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
  end
end
