require 'base64'
require 'openssl'
require 'json'
require 'ruby-debug'
module Ticketevolution
	class Base
	  
	  def initialize(response)
	    @attrs_for_object = response[:body]
	    @response_code    = response[:response_code]
	    @errors           = response[:errors]
	    @server_message   = response[:server_message]
	  end
  
	  class << self
    	def get(path)
    	  if Ticketevolution.token
          path_for_signature = "GET #{path[8..-1]}"
      		call               = construct_call!(path,path_for_signature)
      		call.perform
      		handled_call = handle_response(call)
      		return handled_call
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      def post(path)
    	  if Ticketevolution.token
          path_for_signature = "POST #{path[8..-1]}"
      		call               = construct_call!(path,path_for_signature)
          call.http_post
      		handled_call = handle_response(call)
      		return handled_call
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
      
      # TO ADD
      def http_base
        "#{protocol}://#{environmental_base}"
      end
      
      def protocol
        Ticketevolution.protocol == :https ? "https" : "http"
      end
      
      def environmental_base
        Ticketevolution.mode == :sandbox ? "api.sandbox" : "api"
      end
      
      # returns array of the processed json, the interperted code and any errors for use
      def handle_response(response)
        begin
          header_response      = response.header_str
          header_response_code = response.response_code
          raw_response         = response.body_str
          body                 = JSON.parse(response.body_str)
          mapped_message       = Ticketevolution::RESPONSE_MAP[header_response_code.to_i].last 
          
          return {:body => body, :response_code => header_response, :server_message => mapped_message , :errors => nil}
          
        rescue JSON::ParserError
          return { :body=> nil, :response_code => 500, :server_message => "INVALID JSON" }
        end
      end
    end
	  
	  
	  
  end
end