module TicketEvolution
  module Modules
    module Show
      def show(id, &handler)
        handler ||= method(:build_for_show)
        request(:GET, "/#{id}", &handler)
      end

      alias :find :show

      def build_for_show(response)
        singular_class.new(
          response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message
        })
        )
      end
    end
  end
end
