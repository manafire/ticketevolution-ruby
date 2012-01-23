module TicketEvolution
  module List
    def list(params = nil)
      request(:GET, nil, params)
    end
  end
end
