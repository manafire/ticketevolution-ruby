module TicketEvolution
  module Update
    def update(params = nil)
      request(:PUT, nil, params)
    end
  end
end
