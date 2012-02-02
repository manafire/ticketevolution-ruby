module TicketEvolution
  module Modules
    module Search
      def search(params = nil)
        request(:GET, '/search', params, &method(:build_for_search))
      end

      def build_for_search(response)
        TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.underscore, singular_class)
      end
    end
  end
end
