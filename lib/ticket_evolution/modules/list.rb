module TicketEvolution
  module List
    def list(params = nil)
      request(:GET, nil, params, &method(:build_for_list))
    end

    alias :all :list

    def build_for_list(response)
      TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.downcase, singular_class)
    end
  end
end
