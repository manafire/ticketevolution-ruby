module TicketEvolution
  module Modules
    module Update
      def self.included(klass)
        Class.new{extend SingularClass}.singular_class(klass.name).send(:include, Module.new{
          def update_attributes(params)
            params.merge!({ :id => self.attributes[:id] })
            client_response = plural_class.new({:parent => @connection, :id => params.delete(:id) }).update(params)
            return client_response if client_response.is_a? TicketEvolution::ApiError
            hydrate(client_response)
          end

          def save
            update_attributes(self.attributes)
          end

          private
          def hydrate(client_response)
            client_response.each do |k, v|
              self.send("#{k}=", process_datum(v))
            end
            self
          end
        })
      end

      def update(params = nil)
        ensure_id
        request(:PUT, "", params) do |response|
          client_response = response.body
          client_response.delete(:connection)
          client_response
        end
      end
    end
  end
end
