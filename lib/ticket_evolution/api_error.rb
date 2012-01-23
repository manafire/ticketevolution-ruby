module TicketEvolution
  class ApiError
    attr_reader :error, :message, :code

    def initialize(response)
      @code = response.response_code
      @message = response.server_message
      @error = response.body['error']
    end
  end
end
