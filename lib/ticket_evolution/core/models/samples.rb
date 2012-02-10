module TicketEvolution
  class Models < TicketEvolution::Endpoint
    class Samples < TicketEvolution::Base
      # This class exists to decouple tests of Model from actual functionality
      def initialize(*args); end
      def testing
        "testing"
      end
    end
  end
end
