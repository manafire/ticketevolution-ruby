module TicketEvolution
  module Modules
    module Update
      def self.included(klass)
        Class.new{extend SingularClass}.singular_class(klass.name).send(:include, Module.new{
          def update_attributes(params)
            params.each{|k, v| send("#{k}=", process_datum(v))}
            plural_class.new({:parent => @connection, :id => params.delete(:id)}).update(params)
          end

          def save
            atts = self.attributes
            plural_class.new({:parent => @connection, :id => atts.delete(:id)}).update(atts)
          end
        })
      end

      def update(params = nil)
        raise TicketEvolution::MethodUnavailableError.new "#{self.class.to_s}#update can only be called if there is an id present on this #{self.class.to_s} instance" \
          unless self.respond_to?("id=") and self.id.present?
        request(:PUT, "/#{self.id}", params)
      end
    end
  end
end
