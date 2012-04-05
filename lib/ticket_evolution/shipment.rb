module TicketEvolution
  class Shipment < Model
    def generate_airbill
      plural_class.new(:parent => @connection, :id => self.id).generate_airbill
    end
  end
end
