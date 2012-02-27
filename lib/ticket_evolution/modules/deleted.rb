module TicketEvolution
  module Modules
    module Deleted
      def deleted(params = nil, &handler)
        handler ||= method(:build_for_deleted)
        request(:GET, '/deleted', params, &handler)
      end

      def build_for_deleted(response)
        TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.underscore, singular_class)
      end
    end
  end
end
