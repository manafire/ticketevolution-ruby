module TicketEvolution
  module Deleted
    def deleted(params = nil)
      request(:GET, '/deleted', params, &method(:build_for_deleted))
    end

    def build_for_deleted(response)
      TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.downcase, singular_class)
    end
  end
end
