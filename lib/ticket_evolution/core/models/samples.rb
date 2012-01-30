module TicketEvolution
  class Models < TicketEvolution::Endpoint
    class Samples < TicketEvolution::Base
      # This class exists to decouple tests of Model from actual functionality
      # There must be a better way
    end
  end
end
