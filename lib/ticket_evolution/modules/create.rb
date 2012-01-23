module TicketEvolution
  module Create
    def create(params = nil)
      request(:POST, nil, params)
    end
  end
end
