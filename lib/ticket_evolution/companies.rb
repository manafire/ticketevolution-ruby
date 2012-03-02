module TicketEvolution
  class Companies < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::Destroy
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update
  end
end
