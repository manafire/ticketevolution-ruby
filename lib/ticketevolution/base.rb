require 'base64'
require 'openssl'

module Ticketevolution
	class Base
	  
	  class << self

      %w(delete put get post).each do |verb|
      	define_method("do_#{verb}") do |path|
          request_formatted = "#{verb.upcase} #{path}"
      		call =  Curl::Easy.new(path)


      	end
      end

      private

      def sign!(request)      
        if Ticketevolution.secret
          digest = OpenSSL::Digest::Digest.new('sha256')
          signature = Base64.encode64(OpenSSL::HMAC.digest(digest, Ticketevolution.secret, request)).chomp
          return signature
        else
          raise Ticketevolution::ConfigurationMissing.new("You Must Supply A Secret To Use The API")
        end
      end

    end
	  
	  
	  
  end
end