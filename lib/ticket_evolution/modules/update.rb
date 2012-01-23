module TicketEvolution
  module Update
    def update(params = nil)
      raise TicketEvolution::MethodUnavailableError.new "#{self.class.to_s}#update can only be called if there is an id present on this #{self.class.to_s} instance" \
        if ! self.respond_to?(:id) or self.id.blank?
      request(:PUT, "/#{self.id}", params)
    end
  end
end
