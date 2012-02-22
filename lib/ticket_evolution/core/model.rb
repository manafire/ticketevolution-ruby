module TicketEvolution
  class Model < Builder
    def initialize(params = {})
      @connection = params.delete(:connection)
      raise TicketEvolution::ConnectionNotFound.new \
        "#{self.class.name} must receive a TicketEvolution::Connection object on initialize" \
        unless @connection.is_a? TicketEvolution::Connection
      @scope = params['url'].split('/')[0..2].join('/') if params['url'] =~ /^(\/[a-z_]+s\/\d){2}$/
      super(params)
    end

    def plural_class_name
      parts = ["TicketEvolution", self.class.name.demodulize.pluralize.camelize]
      parts[0] = self.scope[:class] if @scope.present?
      parts.join('::')
    end

    def plural_class
      self.plural_class_name.constantize
    end

    def attributes
      HashWithIndifferentAccess.new(to_hash)
    end

    def attributes=(params)
      params.each do |k, v|
        send("#{k}=", v)
      end
    end

    def scope
      if @scope.present?
        {}.tap do |scope|
          parts = @scope.split('/')
          scope[:class] = "TicketEvolution::#{parts[1].camelize}"
          scope[:id] = parts[2].to_i
        end
      else
        nil
      end
    end

    def new_ostruct_member(name)
      begin
        name = super
        class << self; self; end.class_eval do
          define_method(name) do
            begin
              obj = @table[name]
              unless obj.nil?
                def obj.endpoint=(e); @endpoint = e; end
                def obj.method_missing(method, *args); @endpoint.send(method, *args); end
                named_endpoint = "#{self.plural_class_name}::#{name.to_s.camelize}".constantize
                obj.endpoint = named_endpoint.new(:parent => self.plural_class.new(:id => self.id, :parent => @connection))
              end
              obj
            rescue
              @table[name]
            end
          end
        end
        name
      rescue
        super
      end
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
        "#{plural_class_name}::#{seek}".constantize.new(:parent => plural_class.new(:parent => @connection, :id => self.id))
      else
        super
      end
    end
  end
end



