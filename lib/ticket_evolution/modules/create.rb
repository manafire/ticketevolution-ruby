module TicketEvolution
  module Create
    def create(params = nil)
      @responsible = :create
      request(:POST, nil, params)
    end
  end
end
