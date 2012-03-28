module TicketEvolution
  class Model
    module ParentalBehavior
      def new_ostruct_member(name)
        ostruct_method = super

        named_endpoint = "#{self.plural_class_name}::#{name.to_s.camelize}".constantize
        class << self; self; end.class_eval do
          define_method(name) do
            obj = @table[name.to_sym]
            unless obj.nil?
              def obj.endpoint=(e); @endpoint = e; end
              def obj.method_missing(method, *args); @endpoint.send(method, *args); end
              obj.endpoint = named_endpoint.new(:parent => self.plural_class.new(:id => self.id, :parent => @connection))
            end
            obj
          end
        end
        ostruct_method
      rescue NameError => e
        ostruct_method
      end
    end
  end
end
