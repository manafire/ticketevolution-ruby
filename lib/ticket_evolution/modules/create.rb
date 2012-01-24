module TicketEvolution
  module Create
    def create(params = nil)
      params = { endpoint_name.to_sym => [params] } if params.present?
      request(:POST, nil, params, &method(:build_for_create))
    end

    def build_for_create(response)
      singular_class.new(response.body[endpoint_name].first.merge({
          :status_code => response.response_code,
          :server_message => response.server_message
        })
      )
    end
  end
end
