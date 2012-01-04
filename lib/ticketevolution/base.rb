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
	  
	  def next
	   if self.class.current_page < total_pages
	     yield
	    else
        puts "There are no more objects to be returned in this collection"
	    end
	  end
  
	  class << self
	    # SINGLETON Attributes....
	    attr_accessor :current_page, :total_entries, :total_pages, :per_page, :collection
	    
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
      
      # NEEDS SPEC      
      def process_response(klass,response)
        klass_container = klass_to_response(klass)
        pagination_data = {
          :current_page => response[:body]["current_page"], 
          :total_entries => response[:body]["total_entries"], 
          :per_page => response[:body]["per_page"]
        }
        
        handle_pagination(pagination_data)
        
        # Zero Items Were Found
        if response[:body]["total_entries"].to_i == 0
           puts "Zero Performers With The Query: #{query} Were Found"
         elsif response[:body]["total_entries"].to_i >= 1
           response_for_object                  = {} 
           response_for_object[:body]           = build_hash_for_initializer(klass,klass_container,response)
           response_for_object[:response_code]  = response[:response_code]
           response_for_object[:errors]         = response[:errors]
           response_for_object[:server_message] = response[:server_message]
           
           klass.send(:build,response_for_object)
           # Hit the base class method for creating and map collections of objects or maky perhaps another class...
         else
           # Raise some type of error
         end
        
      end

      
      private
      
      def handle_pagination(stats)
        @total_pages   = stats[:total_entries].to_i <= stats[:per_page] ? 1 : (stats[:total_entries].to_f / stats[:per_page].to_f).ceil
        @current_page  = stats[:current_page]
        @total_entries = stats[:total_entries]
        @per_page      = stats[:per_page]
      end
      
      # NEEDS SPEC
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