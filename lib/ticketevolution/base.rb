require 'base64'
require 'openssl'
require 'ruby-debug'
module Ticketevolution
	class Base
	  
	  class << self
    	def get(path)
    	  if Ticketevolution.token
          request_formatted_for_signature = "GET #{path}"
    		  
      		call = construct_call!(path)
      		call.perform
      		response = call.body_str
          debugger
          dsad="asa"
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      def post(path)
    	  if Ticketevolution.token
          request_formatted_for_signature = "POST #{path}"
    		  
      		call = construct_call!(path)
          call.http_post
          
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      private
      
      def construct_call!(path)
        call =  Curl::Easy.new(path)
        call.headers["X-Signature"] = sign!(path)
        call.headers["X-Token"]     = Ticketevolution.token
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

      
      def process_response
        
      end
      
      
    end
	  
	  
	  
  end
end