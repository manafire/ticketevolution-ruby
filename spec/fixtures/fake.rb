class Fake
  def self.token
    Digest::MD5.hexdigest("fake_token")
  end

  def self.secret
    Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
  end

  def self.response
    OpenStruct.new.tap do |resp|
      resp.header = 'fake header string (we don\'t currently process this)'
      resp.response_code = 200
      resp.body = {:body => "test"}
      resp.server_message = TicketEvolution::Endpoint::RequestHandler::CODES[200].last
    end
  end

  def self.show_response
    r = self.response
    r.body = {
      "url" => "/brokerages/2",
      "updated_at" => "2011-12-18T17:30:06Z",
      "natb_member" => true,
      "name" => "Golden Tickets",
      "id" => "2",
      "abbreviation" => "Golden Tickets"
    }
    r
  end

  def self.list_response
    r = self.response
    r.body = {
       "current_page" => 1,
       "per_page" => 2,
       "brokerages" => [
          {
             "url" => "/brokerages/1",
             "updated_at" => "2011-12-18T19:06:19Z",
             "natb_member" => true,
             "name" => "National Event Company",
             "id" => "1",
             "abbreviation" => "NECO"
          },
          {
             "url" => "/brokerages/2",
             "updated_at" => "2011-12-18T17:30:06Z",
             "natb_member" => true,
             "name" => "Golden Tickets",
             "id" => "2",
             "abbreviation" => "Golden Tickets"
          }
       ],
       "total_entries" => 1379
    }
    r
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
