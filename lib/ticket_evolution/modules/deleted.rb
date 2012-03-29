module TicketEvolution
  module Modules
    module Deleted
      def deleted(params = nil, &handler)
        handler ||= method(:collection_handler)
        request(:GET, '/deleted', params, &handler)
      end
    end
  end
end
