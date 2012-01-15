module TicketEvolution
  class Category < TicketEvolution::Base

    def initiaize(api_response)
      super(api_response)

    end


    class << self
      def list(params_hash)
        query              = build_params_for_get(params_hash)
        path               = "#{api_base}/categories?#{query}"
        response           = TicketEvolution::Base.get(path)
        response           = process_response(TicketEvolution::Category,response)
      end

      def show(id)
        path               = "#{api_base}/categories/#{id}"
        response           = TicketEvolution::Base.get(path,path_for_signature)
        Category.new(response)
      end

      def deleted(params)
        sanitized_parameters = sanitize_parameters(TicketEvolution::Category,"deleted",params) 
        query                = build_params_for_get(params_hash)
        path                 = "#{api_base}/categories/deleted?#{query}"
        response             = TicketEvolution::Base.get(path)
        response             = process_response(TicketEvolution::Category,response)
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end

  end
end
