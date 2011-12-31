module Ticketevolution
  class Performer < Ticketevolution::Base
    attr_accessor :venue_id, :name, :last_event_occurs_at, :updated_at, :category, :id, :url, :upcoming_events, :venue
    
    # AR PROXY TYPE RELATIONSHIP   
    def events(venue); Ticketevolution::Event.find_by_venue(venue);end
        
    def initialize(response)
      debugger
      
      if response.is_a? Array
        debugger
        super(response)
        debugger
        dsd="dsd"
      else
        
        super(response)
              debugger
              dsd="dsd"
        self.name            = @attrs_for_object["name"]
        self.category        = @attrs_for_object["cateogry"]
        self.updated_at      = @attrs_for_object["updated_at"]
        self.id              = @attrs_for_object["id"]
        self.url             = @attrs_for_object["url"]
        self.upcoming_events = @attrs_for_object["upcoming_events"]
        self.venue           = @attrs_for_object["venue"]      
      end
    end
    
    class << self
      def list
        
      end
      
      def search(query)
        path = "#{http_base}.ticketevolution.com/performers/search?=#{query}?"
        path_for_signature = "GET #{path[8..-1]}"
        response           = Ticketevolution::Base.get(path,path_for_signature)
        Performer.new(response)
      end
        
      def show(id)
        path               = "#{http_base}.ticketevolution.com/performers/#{id}?"
        path_for_signature = "GET #{path[8..-1]}"
        response           = Ticketevolution::Base.get(path,path_for_signature)
        Performer.new(response)
      end
      
      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
    
  end
end