module Ticketevolution
  class Event < Ticketevolution::Base
    attr_accessor :category ,:configuration ,:id ,:name ,:occurs_at ,:performances ,:products_count ,:state ,:updated_at ,:url ,:venue
    
    
    def initialize(response)
      super(response)
      
      self.id             = @attrs_for_object["id"]             
      self.url            = @attrs_for_object["url"]
      self.name           = @attrs_for_object["name"]
      self.category       = @attrs_for_object["category"]
      self.updated_at     = @attrs_for_object["updated_at"]
      self.occurs_at      = @attrs_for_object["occurs_at"]
      self.performances   = @attrs_for_object["performances"]
      self.venue          = @attrs_for_object["venue"]
      self.configuration  = @attrs_for_object["configuration"]
      self.state          = @attrs_for_object["state"]
      self.products_count = @attrs_for_object["products_count"]
    end
    
    
    class << self
      def list
        
      end
      
      def search
        
      end
        
      def show(id)
        path     = "#{protocol}://#{environmental_base}.ticketevolution.com/events/#{id}?"
        response = Ticketevolution::Base.get(path)
        Event.new(response)
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
    
  end
end