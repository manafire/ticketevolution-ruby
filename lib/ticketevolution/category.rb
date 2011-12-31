module Ticketevolution
  class Category < Ticketevolution::Base

    def initiaize(api_response)
      super(api_response)
      debugger
      dsad="dsd"
    end
    
    
    class << self
      def list
        
      end
      
      def search
        
      end
        
      def show(id)
        path = "#{http_base}.ticketevolution.com/categories/#{id}?"
        response = Ticketevolution::Base.get(path)

        #Category.new(response)
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
    
  end
end