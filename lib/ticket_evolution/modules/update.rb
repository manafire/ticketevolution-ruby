module TicketEvolution
  module Modules
    module Update
      def self.included(klass)
        Class.new{extend SingularClass}.singular_class(klass.name).send(:include, Module.new{
          def update_attributes(params)
            atts = self.attributes.merge(params)
            id = atts.delete(:id)
            response = plural_class.new({:parent => @connection, :id => id}).update(atts)
            if response.is_a?(TicketEvolution::ApiError)
              response
            else
              self.attributes = response.attributes
              self
            end
          end

          def save
            update_attributes({})
          end
        })
      end

      def update(params = nil, &handler)
        ensure_id
        handler ||= method(:build_for_update)
        request(:PUT, nil, params, &handler)
      end

      def build_for_update(response)
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message
        }))
      end
    end
  end
end
