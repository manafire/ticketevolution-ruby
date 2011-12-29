module Ticketevolution
  class Performer < Ticketevolution::Base

    
    class << self
      def list
        
      end
      
      def search
        
      end
        
      def show(id)
        path = "https://#{environmental_base}.ticketevolution.com/performers/#{id}?"
        response = Ticketevolution::Base.get(path)
        return response
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
    
  end
end