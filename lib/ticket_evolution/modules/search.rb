module TicketEvolution
  module Modules
    module Search
      def search(params = nil, &handler)
        handler ||= method(:build_for_search)
        request(:GET, '/search', params, &handler)
      end

      def build_for_search(response)
        TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.underscore, singular_class)
      end
    end
  end
end
