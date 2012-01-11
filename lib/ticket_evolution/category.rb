module TicketEvolution
  class Category < TicketEvolution::Base

    def initiaize(api_response)
      super(api_response)
      
    end
    
    
    class << self
      def list
        
      end
      
      def search
        
      end
        
      def show(id)
        path               = "#{http_base}.TicketEvolution.com/categories/#{id}?"
        path_for_signature = "GET #{path[8..-1]}"
        response           = TicketEvolution::Base.get(path,path_for_signature)
        #Category.new(response)
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
    
  end
end