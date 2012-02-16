module TicketEvolution
  class Endpoint < Base
    module RequestHandler

      # Response Code Mappings From TicketEvolution API
      CODES = {
        200 => ["OK","Generally returned by successful GET requests. "],
        201 => ["Created","Generally returned by successful POST requests. "],
        202 => ["Accepted","Generally returned when a request has succeeded, but has been scheduled processing at a later time. "],
        301 => ["Moved Permanently","Used when a resource's URL has changed."],
        302 => ["Found","Returned when there's a redirect that should be followed."],
        400 => ["Bad Request","Generally returned on POST and PUT requests when validation fails for the given input. "],
        401 => ["Unauthorized","Returned when the authentication credentials are invalid."],
        404 => ["Not Found","The requested resource could not be located."],
        406 => ["Not Acceptable","The requested content type or version is invalid."],
        422 => ["Unprocessable Entity","Returned when the application can't processes the data."],
        500 => ["Internal Server Error","Used a general error response for processing errors or other issues with the web service. "],
        503 => ["Service Unavailable","Returned when the API service is temporarily unavailable. This could also indicate that the rate limit for the given token has been reached. If this status is received, the request should be retried."]
      }

      def request(method, path, params = nil, &response_handler)
        response = self.build_request(method, path, params)
        response.http(method)
        response = self.naturalize_response(response)
        if response.response_code >= 400
          TicketEvolution::ApiError.new(response)
        else
          response_handler.call(response)
        end
      end

      def build_request(method, path, params = nil)
        raise EndpointConfigurationError, "#{self.class.to_s}#request requires it's first parameter to be a valid HTTP method" unless [:GET, :POST, :PUT, :DELETE].include? method.to_sym
        self.connection.build_request(method, "#{self.base_path}#{path}", params)
      end

      def naturalize_response(response)
        OpenStruct.new.tap do |resp|
          resp.header = response.header_str
          resp.response_code = response.response_code
          resp.body = MultiJson.decode(response.body_str).merge({:connection => self.connection})
          resp.server_message = (CODES[response.response_code] || ['Unknown Error']).last
        end
      end
    end
  end
end
