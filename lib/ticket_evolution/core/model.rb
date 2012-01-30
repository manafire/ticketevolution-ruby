module TicketEvolution
  class Model < Builder
    def initialize(params = {})
      @connection = params.delete(:connection)
      raise TicketEvolution::ConnectionNotFound.new \
        "#{self.class.name} must receive a TicketEvolution::Connection object on initialize" \
        unless @connection.is_a? TicketEvolution::Connection
      super(params)
    end

    def plural_class_name
      "TicketEvolution::#{self.class.name.demodulize.pluralize.camelize}"
    end

    def plural_class
      self.plural_class_name.constantize
    end

    def attributes
      HashWithIndifferentAccess.new(@table)
    end

    private

    def process_datum(v)
      if v.is_a? Hash and v['url'].present?
        name = class_name_from_url(v['url'])
        datum_exists?(name) ? singular_class(class_name_from_url(name)).new(v.merge({:connection => @connection})) : Datum.new(v)
      else
        super
      end
    end

    def method_missing(method, *args)
      seek = method.to_s.camelize
      if seek !~ /=/ and plural_class.const_defined?(seek.to_sym)
        "#{plural_class_name}::#{seek}".constantize.new(:parent => plural_class.new(:connection => @connection, :id => self.id))
      else
        super
      end
    end
  end
end
