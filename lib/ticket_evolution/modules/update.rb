module TicketEvolution
  module Update
    def self.included(klass)
      Class.new{extend SingularClass}.singular_class(klass.name).send(:include, Module.new{
        def update_attributes(params)
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
        if ! self.respond_to?(:id) or self.id.blank?
      request(:PUT, "/#{self.id}", params)
    end
  end
end
