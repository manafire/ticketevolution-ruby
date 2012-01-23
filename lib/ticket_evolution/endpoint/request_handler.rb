module TicketEvolution
  class Endpoint < Base
    module RequestHandler
      def request(method, path, params = nil)
        raise EndpointConfigurationError, "#{self.class.to_s}#request requires it's first parameter to be a valid HTTP method" unless [:GET, :POST, :PUT, :DELETE].include? method.to_sym
        request = self.build_request(method, path, params)
        response = request.http(method)
      end

      def build_request(method, path, params = nil)
        self.connection.build_request(method, "#{self.base_path}#{path}", params)
      end

      def process_response

      end
    end
  end
end
