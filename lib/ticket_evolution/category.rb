module TicketEvolution
  class Category < TicketEvolution::Base
    attr_accessor :parent, :name, :updated_at, :id, :url

    
    def initialize(api_response)
      super(api_response)
      self.id         = @attrs_for_object["id"]
      self.parent     = @attrs_for_object["parent"]
      self.name       = @attrs_for_object["name"]
      self.updated_at = @attrs_for_object["updated_at"]
      self.url        = @attrs_for_object["url"]
    end

    # Anything that appears more then threer times really should be apbstracted out
    class << self
      def list(params)
        sanitized_parameters = sanitize_parameters(TicketEvolution::Category,:list,params) 
        response             = TicketEvolution::Base.get(build_call_path("categories?",build_params_for_get(sanitized_parameters)))
        response             = process_response(TicketEvolution::Category,response)
      end

      def show(id)
        response = TicketEvolution::Base.get(build_call_path("categories/",id))
        Category.new(response)
      end

      def deleted(params)
        sanitized_parameters = sanitize_parameters(TicketEvolution::Category,:delete,params) 
        response             = self.get(build_call_path("categories/deleted?",build_params_for_get(sanitized_parameters)))
        response             = process_response(TicketEvolution::Category,response)
      end
      
      # Construction Methods From Raw JSON
      def raw_from_json(category)
        ActiveSupport::HashWithIndifferentAccess.new({
          :name           => category['id'],
          :category       => category["url"],
          :url            => category["parent"],
          :id             => category["name"].to_i,
          :updated_at     => category["updated_at"]
        })
      end
      
      def build_for_category(response)
        categories                             = response[:body].inject([]) do |categories,category|
          response_for_object                  = {}
          response_for_object[:body]           = category
          response_for_object[:response_code]  = response[:response_code]
          response_for_object[:errors]         = response[:errors]
          response_for_object[:server_message] = response[:server_message]

          categories.push(Category.new(response_for_object))
        end
        TicketEvolution::Category.collection = categories
        return categories
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end

  end
end
