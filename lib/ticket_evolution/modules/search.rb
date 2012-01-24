module TicketEvolution
  module Search
    def search(params = nil)
      request(:GET, '/search', params)
    end
  end
end
