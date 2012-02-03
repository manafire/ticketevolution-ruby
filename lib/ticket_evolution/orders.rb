module TicketEvolution
  class Orders < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    alias :create_brokerage_order :create
    alias :create_customer_order :create

    def accept_order(params = nil)
      raise TicketEvolution::MethodUnavailableError.new \
        "#{self.class.to_s}#accept_order can only be called if there is an id present on this #{self.class.to_s} instance" \
        unless self.respond_to?("id=") and self.id.present?
      request(:POST, "/#{self.id}/accept", params, &method(:build_for_create))
    end

    def create_fulfillment_order(params = nil)
      request(:POST, "/fulfillments", params, &method(:build_for_create))
    end
  end
end
