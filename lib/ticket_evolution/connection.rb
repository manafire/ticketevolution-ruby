module TicketEvolution
  class Connection
    include TicketEvolution::Helpers::Base
    attr_accessor :token, :secret, :version, :mode

    def initialize(options = {})
      options.each {|k, v| send("#{k}=", v)}
    end

    def get(path, query_string = nil)
      raise TicketEvolution::InvalidConfiguration.new("You must supply all credentials to use the API") unless token && secret
      uri = build_call_path(path, query_string)
      uri_for_signature  = "GET #{uri[8..-1]}"
      call                = construct_call!(uri, uri_for_signature)
      call.perform
      handle_response(call)
    end

    private

    def api_base;           "#{http_base}.ticketevolution.com";                       end
    def http_base;          "https://#{environmental_base}";                          end
    def environmental_base; mode == :sandbox ? "api.sandbox" : "api"; end

    def build_call_path(path,query)
      "#{api_base}/#{path}#{query}"
    end

    def construct_call!(path, path_for_signature)
      raise TicketEvolution::InvalidConfiguration.new("You Must Supply A Token To Use The API") unless token

      call = Curl::Easy.new(path)
      call.headers["X-Signature"] = sign!(path_for_signature)
      call.headers["X-Token"] = token
      call.headers["Accept"] = "application/vnd.ticketevolution.api+json; version=8"
      call
    end

    def sign!(path_for_signature)
      raise TicketEvolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API") unless secret
      digest = OpenSSL::Digest::Digest.new('sha256')
      signature = Base64.encode64(OpenSSL::HMAC.digest(digest, secret, path_for_signature)).chomp
    end

    # returns array of the processed json, the interperted code and any errors for use
    def handle_response(response)
      header_response      = response.header_str
      header_response_code = response.response_code
      raw_response         = response.body_str
      body                 = JSON.parse(response.body_str)
      mapped_message       = TicketEvolution::Helpers::Http::Codes[header_response_code].last

      return {
        :body => body,
        :response_code => header_response_code,
        :server_message => mapped_message ,
        :errors => nil}

      rescue JSON::ParserError
        return { :body=> nil, :response_code => 500, :server_message => "INVALID JSON" }
    end
  end
end
