module TicketEvolution
  module List
    def list(params = nil)
      @responsible = :list
      request(:GET, nil, params)
    end
  end
end
