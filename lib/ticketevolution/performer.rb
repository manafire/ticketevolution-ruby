module Ticketevolution
  class Performer < Ticketevolution::Base
    attr_accessor :venue_id, :name, :last_event_occurs_at, :updated_at, :category, :id, :url, :upcoming_events, :venue 
  
    # AR PROXY TYPE RELATIONSHIP   
    def events(venue); Ticketevolution::Event.find_by_venue(venue);end
        
    def initialize(response)
        super(response)
        self.name            = @attrs_for_object["name"] || @attrs_for_object[:name] 
        self.category        = @attrs_for_object["cateogry"] || nil
        self.updated_at      = @attrs_for_object["updated_at"]  || nil
        self.id              = @attrs_for_object["id"] || nil
        self.url             = @attrs_for_object["url"] || nil
        self.upcoming_events = @attrs_for_object["upcoming_events"] || nil
        self.venue           = @attrs_for_object["venue"] || nil     
    end
    
    class << self
      
      def build(response)
        performers = response[:body].inject([]) do |performers,performer|
          response_for_object = {}
          response_for_object[:body]           = performer
          response_for_object[:response_code]  = response[:response_code]                    
          response_for_object[:errors]         = response[:errors]                         
          response_for_object[:server_message] = response[:server_message]                         
          
          performers.push(Performer.new(response_for_object))
        end
        Ticketevolution::Performer.collection = performers
        return performers
      end
      
      def list(params_hash)
        query              = build_params_for_get(params_hash)
        path               = "#{http_base}.ticketevolution.com/performers?#{query}"
        path_for_signature = "GET #{path[8..-1]}"
        response           = Ticketevolution::Base.get(path,path_for_signature)
        
        if !response[:body][:performers]
          # THROW ERROR TO ADD![DKM 2012.1.2]
        end
      end
      
      def search(query)
        query              = query.encoded 
        path               = "#{http_base}.ticketevolution.com/performers/search?q=#{query}"
        path_for_signature = "GET #{path[8..-1]}"
        response           = Ticketevolution::Base.get(path,path_for_signature)
        response           = process_response(Ticketevolution::Performer,response)
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