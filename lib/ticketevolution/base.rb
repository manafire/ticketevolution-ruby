require 'base64'
require 'openssl'
require 'json'
require 'ruby-debug'
module Ticketevolution
	class Base
	  
	  class << self
    	def get(path)
    	  if Ticketevolution.token
          path_for_signature = "GET #{path[8..-1]}"
          puts path_for_signature    		  
      		call               = construct_call!(path,path_for_signature)
      		call.perform
      		handle_response(call.body_str)
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      def post(path)
    	  if Ticketevolution.token
          path_for_signature = "POST #{path[8..-1]}"
    		  
      		call               = construct_call!(path,path_for_signature)
          call.http_post
          handle_response(call.body_str)
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      private
      
      def construct_call!(path,path_for_signature)
        if !Ticketevolution.token.nil?
          call                        = Curl::Easy.new(path)
          call.headers["X-Signature"] = sign!(path_for_signature)
          call.headers["X-Token"]     = Ticketevolution.token
          call.headers["Accept"]      = "application/vnd.ticketevolution.api+json; version=8"
          return call
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Token To Use The API") 
        end
      end
      
      def sign!(path_for_signature)     
        if Ticketevolution.secret
          digest = OpenSSL::Digest::Digest.new('sha256')
          signature = Base64.encode64(OpenSSL::HMAC.digest(digest, Ticketevolution.secret, path_for_signature)).chomp
          return signature
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
      end
      
      def environmental_base
        Ticketevolution.mode == :sandbox ? "api.sandbox" : "api"
      end
      
      # returns array of the processed json, the interperted code and any errors for use
      def handle_response(response)
        begin
          
          
          # process json
          
          # associate response code with what occurred
          # return back raw jason to make objects
          response = JSON.parse(response)
          
          
        rescue JSON::ParserError
          return [nil,500,"INVALID JSON"]   
        end
          
        
      end
      
      
    end
	  
	  
	  
  end
end