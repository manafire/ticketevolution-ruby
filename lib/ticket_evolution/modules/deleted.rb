module TicketEvolution
  module Deleted
    def deleted(params = nil)
      @responsible = :deleted
      request(:GET, '/deleted', params)
    end
  end
end
