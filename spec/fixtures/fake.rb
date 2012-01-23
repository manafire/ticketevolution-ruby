class Fake
  def self.token
    Digest::MD5.hexdigest("fake_token")
  end

  def self.secret
    Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
  end
end
