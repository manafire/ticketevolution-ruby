class Fake
  def self.token
    Digest::MD5.hexdigest("fake_token")
  end

  def self.secret
    Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
  end

  def self.response
    OpenStruct.new.tap do |resp|
      resp.header = ''
      resp.response_code = 200
      resp.body = {:body => "test"}
      resp.server_message = TicketEvolution::Endpoint::RequestHandler::CODES[200].last
    end
  end

  def self.error_response
    OpenStruct.new.tap do |resp|
      resp.header = ''
      resp.response_code = 500
      resp.body = {'error' => 'Internal Server Error'}
      resp.server_message = TicketEvolution::Endpoint::RequestHandler::CODES[500].last
    end
  end
end
