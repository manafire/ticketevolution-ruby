module TicketEvolution
  module Search
    def search(params = nil)
      request(:GET, '/search', params, &method(:build_for_search))
    end

    def build_for_search(response)
      TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.downcase, singular_class)
    end
  end
end
