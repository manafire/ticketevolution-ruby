module TicketEvolution
  class Order < Model
    def accept(params)
      plural_class.new(:parent => @connection).accept_order(params)
    end

    def complete
      plural_class.new(:parent => @connection).complete_order
    end

    def reject(params)
      plural_class.new(:parent => @connection).reject_order(params)
    end
  end
end
