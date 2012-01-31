module TicketEvolution
  class Endpoint < Base
    include RequestHandler
    include SingularClass

    def initialize(options = nil)
      raise EndpointConfigurationError, "#{self.class.to_s} instances require a hash as their first parameter" unless options.is_a? Hash
      raise EndpointConfigurationError, "The options hash must include a parent key / value pair" unless options[:parent].present?
      raise EndpointConfigurationError, "#{self.class.to_s} instances require a parent which inherits from TicketEvolution::Base" unless options[:parent].kind_of? TicketEvolution::Base
      options.each do |k, v|
        self.singleton_class.send(:attr_accessor, k)
        send("#{k}=", v)
      end
      raise EndpointConfigurationError, "The parent passed in the options hash must be a TicketEvolution::Connection object or have one in it's parent chain" unless has_connection?
    end

    def base_path
      [].tap do |parts|
        parts << parent.base_path if parent.kind_of? TicketEvolution::Endpoint
        parts << "/"+self.class.to_s.split('::').last.downcase
        parts << "/#{self.id}" if self.respond_to?(:id) and self.id.present?
      end.join
    end

    def connection
      if self.parent.is_a? TicketEvolution::Connection
        self.parent
      elsif self.parent.respond_to? :parent
        self.parent.connection
      else
        nil
      end
    end

    def has_connection?
      connection.present?
    end

    def endpoint_name
      self.class.name.demodulize.downcase
    end
  end
end
