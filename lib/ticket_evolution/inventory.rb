module TicketEvolution
  class Inventory < Endpoint
    include TicketEvolution::Modules::List

    def singular_class
      TicketEvolution::InventoryItem
    end

    def collection_handler(response)
      TicketEvolution::Collection.build_from_response(response, 'inventory', singular_class)
    end
  end
end
