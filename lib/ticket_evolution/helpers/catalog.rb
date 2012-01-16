module TicketEvolution
  module Helpers
    module Catalog

      # Association Proxy Dynamic Methods
      %w(performer configuration category venue).each do |klass|
        define_method("build_for_#{klass}".intern) do |response|
          klass_for_object = "TicketEvolution::#{klass.capitalize}".constantize
          created_items = response[:body].inject([]) do |collection,object|
            response_for_object = {}
            response_for_object[:body]           = object
            response_for_object[:response_code]  = response[:response_code]
            response_for_object[:errors]         = response[:errors]
            response_for_object[:server_message] = response[:server_message]
            new_object = klass_for_object.send(:new,response_for_object)
            collection.push(new_object)
          end
          klass_for_object.send("collection=".intern,created_items)
          return collection
        end
      end

      # Begging for beging turning meta like above
      def build_hash_for_initializer(klass,klass_container,response)
        if klass == (TicketEvolution::Performer)
          performers = response[:body][klass_container].inject([]) do |performers, performer|
            performer_hash = TicketEvolution::Performer.raw_from_json(performer)
            performers.push(performer_hash)
          end
          return performers
        elsif klass == (TicketEvolution::Venue)
          venues = response[:body][klass_container].inject([]) do |venues, venue|
            venues_hash = TicketEvolution::Venue.raw_from_json(venue)
            venues.push(venues_hash)
          end
          return venues
        elsif klass == (TicketEvolution::Category)
          categories = response[:body][klass_container].inject([]) do |categories, catagory|
            categories_hash = TicketEvolution::Category.raw_from_json(catagory)
            categories.push(categories_hash)
          end
          return categories
        elsif klass == (TicketEvolution::Event)
          events = response[:body][klass_container].inject([]) do |events, event|
            event_hash = TicketEvolution::Event.raw_from_json(event)
            events.push(event_hash)
          end
          return events
        end
      end

      def klass_container(klass); klass_to_response_container(klass); end
      def klass_to_response_container(klass)
        if    klass == (TicketEvolution::Performer)   then return "performers"
        elsif klass == (TicketEvolution::Venue)       then return "venues"
        elsif klass == (TicketEvolution::Category)    then return "categories"
        elsif klass == (TicketEvolution::Event)       then return "events"
        end
      end
    end
  end
end
