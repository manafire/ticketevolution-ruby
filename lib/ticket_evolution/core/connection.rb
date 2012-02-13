module TicketEvolution
  class Connection < Base
    cattr_reader :default_options, :expected_options, :oldest_version_in_service
    cattr_accessor :protocol, :url_base

    @@oldest_version_in_service = 8

    @@default_options = HashWithIndifferentAccess.new({
      :version => @@oldest_version_in_service,
      :mode => :sandbox,
      :ssl_verify => true,
      :logger => nil
    })

    @@expected_options = [
      'version',
      'mode',
      'token',
      'secret',
      'ssl_verify',
      'logger'
    ]

    @@url_base = "ticketevolution.com"
    @@protocol = "https"

    def initialize(opts = {})
      @config = self.class.default_options.merge(opts)
      @config.delete_if{|k, v| ! TicketEvolution::Connection.expected_options.include?(k)}

      # Error Notification
      if @config.keys.sort_by{|x|x} == TicketEvolution::Connection.expected_options.sort_by{|x|x}
        raise InvalidConfiguration.new("Invalid Token Format") unless @config[:token] =~ /^[a-zA-Z0-9]{32}$/
        raise InvalidConfiguration.new("Invalid Secret Format") unless @config[:secret] =~ /^\S{40}$/
        raise InvalidConfiguration.new("Please Use API Version #{TicketEvolution::Connection.oldest_version_in_service} or Above") unless @config[:version] >= TicketEvolution::Connection.oldest_version_in_service
      else
        raise InvalidConfiguration.new("Missing: #{(self.class.expected_options - @config.keys).join(', ')}")
      end
    end

    def url
      @url ||= [].tap do |parts|
        parts << TicketEvolution::Connection.protocol
        parts << "://api."
        parts << "#{@config[:mode]}." if @config[:mode].present? && @config[:mode].to_sym != :production
        parts << TicketEvolution::Connection.url_base
      end.join
    end

    def sign(method, path, content = nil)
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha256'),
          @config[:secret],
          "#{method} #{process_params(method, path, content).gsub(TicketEvolution::Connection.protocol+'://', '').gsub(/\:\d{2,5}\//, '/')}"
      )).chomp
    end

    def build_request(method, path, params = nil)
      uri = URI.join(self.url, path).to_s
      Curl::Easy.new(generate_url(method, uri, params)) do |request|
        if @config.has_key?(:ssl_verify)
          request.ssl_verify_host = @config[:ssl_verify]
          request.ssl_verify_peer = @config[:ssl_verify]
        end
        if self.logger.present?
          request.on_debug { |type, data| self.logger << data }
        end
        request.post_body = post_body(params) unless method == :GET
        request.headers["Accept"] = "application/vnd.ticketevolution.api+json; version=#{@config[:version]}"
        request.headers["X-Signature"] = sign(method, uri, params)
        request.headers["X-Token"] = @config[:token]
      end
    end

    def logger
      @config[:logger]
    end

    private

    def post_body(params)
      MultiJson.encode(params)
    end

    def generate_url(method, uri, params)
      case method
      when :GET
        process_params(method, uri, params)
      else
        uri
      end
    end

    def process_params(method, path, params)
      suffix = if params.present?
        case method
        when :GET
          params.to_query
        else
          post_body(params)
        end
      end

      "#{URI.join(url, path).to_s}?" + suffix.to_s
    end
  end
end
