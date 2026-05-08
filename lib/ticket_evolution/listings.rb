module TicketEvolution
  class Listings < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show

    def collection_handler(response)
      TicketEvolution::Collection.build_from_response(response, 'ticket_groups', singular_class)
    end
  end
end
