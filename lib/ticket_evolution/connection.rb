module TicketEvolution
  class Connection
    cattr_reader :default_options, :expected_options, :oldest_version_in_service
    cattr_accessor :protocol, :url_base

    @@oldest_version_in_service = 8

    @@default_options = HashWithIndifferentAccess.new({
      :version => @@oldest_version_in_service,
      :mode => :sandbox
    })

    @@expected_options = [
      'version',
      'mode',
      'token',
      'secret'
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
        parts << "#{@config[:mode]}." unless @config[:mode] == :production
        parts << TicketEvolution::Connection.url_base
      end.join
    end

    def sign(method, path, content)
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha256'),
          @config[:secret],
          "#{method} #{process_content(method, path, content).gsub(TicketEvolution::Connection.protocol+'://', '')}"
      )).chomp
    end

    def build_request(method, path, content)
      Curl::Easy.new(process_content(method, path, content)) do |request|
        request.headers["Accept"] = "application/vnd.ticketevolution.api+json; version=#{@config[:version]}"
        request.headers["X-Signature"] = sign(method, path, content)
        request.headers["X-Token"] = @config[:token]
      end
    end

    private

    def process_content(method, path, content)
      "#{URI.join(url, path).to_s}?" + case method
      when :GET
        content.to_query
      else
        MultiJson.encode(content)
      end
    end
  end
end
