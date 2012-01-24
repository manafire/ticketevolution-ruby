module TicketEvolution
  module Search
    def search(params = nil)
      @responsible = :search
      request(:GET, '/search', params)
    end
  end
end
