module TicketEvolution
  class Clients < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update
    # TODO: cancel
    # TODO: refund
    # TODO: apply
    # TODO: status
  end
end
