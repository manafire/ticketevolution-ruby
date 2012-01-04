require 'base64'
require 'openssl'
require 'json'
require 'ruby-debug'
module Ticketevolution
	class Base
    attr_accessor :current_page, :total_items, :total_pages
    
	  def initialize(response)
	    @attrs_for_object = response[:body]
	    @response_code    = response[:response_code]
	    @errors           = response[:errors]
	    @server_message   = response[:server_message]
	  end
  
	  class << self
    	def get(path,path_for_signature)
    	  if Ticketevolution.token
          path_for_signature = "GET #{path[8..-1]}"
      		call                = construct_call!(path,path_for_signature)
      		call.perform
      		handled_call = handle_response(call)
      		return handled_call
        else
          raise Ticketevolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
    	end

      def post(path,path_for_signature)
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
      
      
      def process_response(klass,response)
        klass_container = klass_to_response(klass)

        # Zero Items Were Found
        if response[:body][klass_container].length == 0
           puts "Zero Performers With The Query: #{query} Were Found"
         elsif response[:body][klass_container].length == 1
           handle_pagination!
           response_for_object                  = {} 
           response_for_object[:body]           = build_hash_for_initializer(klass,klass_container,response)
           response_for_object[:response_code]  = response[:response_code]
           response_for_object[:errors]         = response[:errors]
           response_for_object[:server_message] = response[:server_message]

           klass.send(:build,response_for_object)
         elsif response[:body][klass_container].length > 1  
           # Hit the base class method for creating and map collections of objects or maky perhaps another class...
         else
           # Raise some type of error
         end
        
      end

      
      private
      
      def handle_pagination!
        
      end
      
      def build_hash_for_initializer(klass,klass_container,response)
        if klass == (Ticketevolution::Performer)
          performers = response[:body][klass_container].inject([]) do |performers, performer|
            
            performer_hash = ActiveSupport::HashWithIndifferentAccess.new({ 
              :name       => performer['name'], 
              :category   => performer["category"],  
              :url        => performer["url"], 
              :id         => performer["id"].to_i, 
              :updated_at => performer["updated_at"]
            })
            performers.push(performer_hash)
          end   
          return performers
        elsif klass == (Ticketevolution::Venue)       
          
        elsif klass == (Ticketevolution::Category)    
          
        elsif klass == (Ticketevolution::Event)       
          
        end
        
   
      end
      
      def klass_to_response(klass)
        if    klass == (Ticketevolution::Performer)   then return "performers"
        elsif klass == (Ticketevolution::Venue)       then return "venues"
        elsif klass == (Ticketevolution::Category)    then return "categories"
        elsif klass == (Ticketevolution::Event)       then return "events"   
        end
      end
      
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
          mapped_message       = Ticketevolution::HTTP_CODE[header_response_code.to_i].last 
          
          return {:body => body, :response_code => header_response, :server_message => mapped_message , :errors => nil}
          
        rescue JSON::ParserError
          return { :body=> nil, :response_code => 500, :server_message => "INVALID JSON" }
        end
      end
      
      def build_params_for_get(params)
        get_params = params.keys.inject([]) do |memo,key|
          current_parameter =  key.to_s + "=" + params[key].to_s
          memo.push(current_parameter)
        end

        get_params = get_params.sort.join("&")
        return get_params
      end
    end
	  
  end
end