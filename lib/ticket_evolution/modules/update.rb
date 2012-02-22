module TicketEvolution
  module Modules
    module Update
      def self.included(klass)
        Class.new{extend SingularClass}.singular_class(klass.name).send(:include, Module.new{
          def update_attributes(params)
            params.each{|k, v| send("#{k}=", process_datum(v))}
            atts = self.attributes
            id = atts.delete(:id)
            plural_class.new({:parent => @connection, :id => id}).update(atts)
          end

          def save
            atts = self.attributes
            plural_class.new({:parent => @connection, :id => atts.delete(:id)}).update(atts)
          end
        })
      end

      def update(params = nil)
        ensure_id
        request(:PUT, "/#{self.id}", params)
      end
    end
  end
end
