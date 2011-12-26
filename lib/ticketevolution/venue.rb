module Ticketevolution
  class Venue < Ticketevolution::Base
    attr_accessor :name, :address, :location, :updated_at, :url, :id, :upcoming_events
    
    class << self
      def list
        
      end
      
      def search
        
      end
        
      def show(id)
        path = "https://#{environmental_base}.ticketevolution.com/venues/#{id}?"
        response = Ticketevolution::Base.get(path)
        puts response
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
    
  end
end