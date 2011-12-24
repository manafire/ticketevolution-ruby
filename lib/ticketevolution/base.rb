require 'base64'
require 'openssl'

module Ticketevolution
	class Base
	  
	  class << self


    	def get(path)
    	  
    	  if Ticketevolution.token
          request_formatted_for_signature = "#{verb.upcase} #{path}"
      		signature                       = sign!(request_formatted_for_signature)
    		  
      		call = construct_call!(path)
      		call.perform
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      def post(path)
    	  
    	  if Ticketevolution.token
          request_formatted_for_signature = "#{verb.upcase} #{path}"
      		signature                       = sign!(request_formatted_for_signature)
    		  
      		call = construct_call!(path)
          call.http_post
          
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      private
      
      def construct_call!(path)
        call =  Curl::Easy.new(path)
        call.headers["X-Signature"] = signature
        call.headers["X-Toekn"]     = Ticketevolution.token
        call.headers["Accept"]      = "application/vnd.ticketevolution.api+json; version=8"
        call
      end
      
      def sign!(request)      
        if Ticketevolution.secret
          digest = OpenSSL::Digest::Digest.new('sha256')
          signature = Base64.encode64(OpenSSL::HMAC.digest(digest, Ticketevolution.secret, request)).chomp
          return signature
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
      end

    end
	  
	  
	  
  end
end