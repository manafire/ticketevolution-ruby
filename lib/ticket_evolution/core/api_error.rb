module TicketEvolution
  class ApiError < Model
    attr_reader :message, :code

    def initialize(response)
      @code = response.response_code
      @message = response.server_message
      super(response.body)
      self.freeze
    end
  end
end
