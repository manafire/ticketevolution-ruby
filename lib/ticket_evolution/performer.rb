module TicketEvolution
  class Performer < TicketEvolution::Base
    attr_accessor :venue_id, :name, :last_event_occurs_at, :updated_at, :category, :id, :url, :upcoming_events, :venue

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

    # DOES NOT RETURN THE RIGT ARTISTS
    def events; TicketEvolution::Event.find_by_performer(id); end

    class << self

      def list(params_hash)
        query              = build_params_for_get(params_hash)
        path               = "#{api_base}/performers?#{query}"
        response           = TicketEvolution::Base.get(path)
        response           = process_response(TicketEvolution::Performer,response)
      end

      def search(query)
        query              = query.encoded
        path               = "#{api_base}/performers/search?q=#{query}"
        response           = TicketEvolution::Base.get(path)
        response           = process_response(TicketEvolution::Performer,response)
      end

      def show(id)
        path               = "#{api_base}/performers/#{id}"
        response           = TicketEvolution::Base.get(path)
        Performer.new(response)
      end

      # Builders For Array Responses , Template for Object
      def raw_from_json(performer)
        ActiveSupport::HashWithIndifferentAccess.new({
          :name       => performer['name'],
          :category   => performer["category"],
          :url        => performer["url"],
          :id         => performer["id"].to_i,
          :updated_at => performer["updated_at"]
        })
      end

      # Acutal api endpoints are matched 1-to-1 but for AR style convience AR type method naming is aliased into existance
      alias :find :show
    end
  end
end
