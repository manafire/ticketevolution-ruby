module TicketEvolution
  class Base
    def method_missing(method, *args)
      "TicketEvolution::#{method.to_s.camelize.to_sym}".constantize.new({:parent => self}) rescue super
    end
  end
end
