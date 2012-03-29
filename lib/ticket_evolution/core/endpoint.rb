module TicketEvolution
  class Endpoint < Base
    include RequestHandler
    include SingularClass

    def initialize(options = nil)
      raise EndpointConfigurationError, "#{self.class.to_s} instances require a hash as their first parameter" unless options.is_a? Hash
      raise EndpointConfigurationError, "The options hash must include a parent key / value pair" unless options[:parent].present?
      raise EndpointConfigurationError, "#{self.class.to_s} instances require a parent which inherits from TicketEvolution::Base" unless options[:parent].kind_of? TicketEvolution::Base
      @options = options.with_indifferent_access
      raise EndpointConfigurationError, "The parent passed in the options hash must be a TicketEvolution::Connection object or have one in it's parent chain" unless has_connection?
    end

    def base_path
      [].tap do |parts|
        parts << parent.base_path if parent.kind_of? TicketEvolution::Endpoint
        parts << "/"+endpoint_name
        parts << "/#{self.id}" if self.id.present?
      end.join
    end

    def connection
      if self.parent.is_a? TicketEvolution::Connection
        self.parent
      elsif self.parent.kind_of? TicketEvolution::Endpoint
        self.parent.connection
      else
        nil
      end
    end

    def has_connection?
      connection.present?
    end

    def endpoint_name
      self.class.name.demodulize.underscore
    end

    def method_missing(method, *args)
      name = method.to_s
      @options.keys.include?(name) ? @options[name] : super
    end

    # Ruby 1.8.7 / REE compatibility
    def id
      @options[:id]
    end

    private

    def ensure_id
      raise TicketEvolution::MethodUnavailableError.new \
        "#{self.class.to_s}##{caller.first.split('`').last.split("'").first} can only be called if there is an id present on this #{self.class.to_s} instance" \
        unless self.id.present?
    end
  end
end
