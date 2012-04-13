module TicketEvolution
  class ApiError < Model
    attr_reader :message, :status_code
    alias :code :status_code

    def initialize(response)
      @status_code = response.response_code
      @message = response.server_message
      super(response.body)
      self.freeze
    end
  end
end
