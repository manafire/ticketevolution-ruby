module TicketEvolution
  module Modules
    module Search
      def search(params = nil, &handler)
        handler ||= method(:collection_handler)
        request(:GET, '/search', params, &handler)
      end
    end
  end
end
