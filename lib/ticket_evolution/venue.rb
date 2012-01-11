module TicketEvolution
  class Venue < TicketEvolution::Base
    attr_accessor :name, :address, :location, :updated_at, :url, :id, :upcoming_events
    
    def initialize(response)
      super(response)
      self.name            = @attrs_for_object["name"]
      self.address         = @attrs_for_object["address"]
      self.location        = @attrs_for_object["location"]
      self.updated_at      = @attrs_for_object["ipdated_at"]
      self.url             = @attrs_for_object["url"]
      self.id              = @attrs_for_object["id"]
      self.upcoming_events = @attrs_for_object["upcoming_events"]
    end

    def events; TicketEvolution::Event.find_by_venue(id); end
      
    class << self
      
      def list(params_hash)
        query              = build_params_for_get(params_hash).encoded
        path               = "#{http_base}.TicketEvolution.com/performers?#{query}"
        path_for_signature = "GET #{path[8..-1]}"
        response           = TicketEvolution::Base.get(path,path_for_signature)
        response           = process_response(TicketEvolution::Venue,response)
      end
      
      def search(query)
        path               = "#{http_base}.TicketEvolution.com/venues/search?q=#{query}"
        path_for_signature = "GET #{path[8..-1]}"
        response           = TicketEvolution::Base.get(path,path_for_signature)
        response           = process_response(TicketEvolution::Venue,response)
      end
        
      def show(id)
        path               = "#{http_base}.TicketEvolution.com/venues/#{id}?"
        path_for_signature = "GET #{path[8..-1]}"
        response           = TicketEvolution::Base.get(path,path_for_signature)
        Venue.new(response)
      end
      
      
      # Association Proxy Dynamic Methods
      %w(performer configuration category occurs_at name).each do |facet|
        parameter_name = ["name","occurs_at"].include?(facet) ? facet : "#{facet}_id"
        define_method("find_by_#{facet}") do |parameter|
          self.list({parameter_name.intern => parameter})
        end
      end
      
      # Builders For Array Responses , Template for Object
      def raw_from_json(venue)
        ActiveSupport::HashWithIndifferentAccess.new({ 
          :name            => venue['name'],
          :address         => venue['address'],
          :location        => venue['location'],
          :updated_at      => venue['updated_at'],
          :url             => venue['url'],
          :id              => venue['id'],
          :upcoming_events => venue['upcoming_events']
        })
      end

      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
    
  end
end