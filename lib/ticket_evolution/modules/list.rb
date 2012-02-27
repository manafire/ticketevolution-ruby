module TicketEvolution
  module Modules
    module List
      def list(params = nil, &handler)
        handler ||= method(:build_for_list)
        request(:GET, nil, params, &handler)
      end

      alias :all :list

      def build_for_list(response)
        TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.underscore, singular_class)
      end
    end
  end
end
