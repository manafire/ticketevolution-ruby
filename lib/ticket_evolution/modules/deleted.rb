module TicketEvolution
  module Deleted
    def deleted(params = nil)
      request(:GET, '/deleted', params)
    end
  end
end
