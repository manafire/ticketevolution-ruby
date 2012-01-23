module TicketEvolution
  module Show
    def show(id)
      request(:GET, "/#{id}")
    end
  end
end
