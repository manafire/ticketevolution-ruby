module TicketEvolution
  module Modules
    module Create
      def create(params = nil, &handler)
        handler ||= method(:build_for_create)
        params = { endpoint_name.to_sym => [params] } if params.present?
        request(:POST, nil, params, &handler)
      end

      def build_for_create(response)
        singular_class.new(response.body[endpoint_name].first.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end
  end
end
