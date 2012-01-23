module TicketEvolution
  class Base
    def method_missing(method, *args)
      seek = method.to_s.singularize.camelize.to_sym
      if TicketEvolution.const_defined?(seek)
        "TicketEvolution::#{seek}".constantize.new({:parent => self})
      else
        super
      end
    end
  end
end
