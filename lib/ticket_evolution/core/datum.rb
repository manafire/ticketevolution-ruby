module TicketEvolution
  class Datum < Builder
    def [](key)
      send(key)
    end
  end
end
