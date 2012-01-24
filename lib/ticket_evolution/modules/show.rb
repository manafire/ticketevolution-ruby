module TicketEvolution
  module Show
    def show(id)
      @responsible = :show
      request(:GET, "/#{id}")
    end

    def build_for_show(response)
      "TicketEvolution::#{self.class.to_s.split('::').last.singularize.camelize}".constantize.new(
        response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message
        })
      )
      remove_instance_variable(:@responsible)
    end
  end
end
