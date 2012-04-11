module TicketEvolution
  class Shipment < Model
    def generate_airbill
      plural_class.new(:parent => @connection, :id => self.id).generate_airbill
    end
    def cancel
      plural_class.new(:parent => @connection, :id => self.id).cancel_shipment
    end
  end
end
