require 'base64'
require 'openssl'
require 'json'
require 'ruby-debug'
module TicketEvolution
  class Base
    extend ::TicketEvolution::Helpers::Base
    extend ::TicketEvolution::Helpers::Catalog

    # move up the repeted api_base calls that are sprinkled within the subclasses 
    
    def initialize(response)
      @attrs_for_object = response[:body]
      @response_code    = response[:response_code]
      @errors           = response[:errors]
      @server_message   = response[:server_message]
    end


    class << self
      attr_accessor :current_page, :total_entries, :total_pages, :per_page, :collection

      def get(path)
        if TicketEvolution.token
          path_to_use         = path
          path_for_signature  = "GET #{path_to_use[8..-1]}"
          call                = construct_call!(path,path_for_signature)
          call.perform
          
          handled_call = handle_response(call)
          return handled_call
        else
          raise TicketEvolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
      end

      def post(path)
        if TicketEvolution.token
          path_to_use         = CGI.unescape(path)
          path_for_signature = "POST #{path[8..-1]}"
          call               = construct_call!(path,path_for_signature)
          call.http_post
          handled_call = handle_response(call)
          return handled_call
        else
          raise TicketEvolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
      end

      # NEEDS SPEC
      def process_response(klass,response)
        pagination_data = {
          :current_page => response[:body]["current_page"],
          :total_entries => response[:body]["total_entries"],
          :per_page => response[:body]["per_page"]
        }

        handle_pagination(pagination_data)
        handle_processing_items(response,klass)
      end


      def handle_processing_items(response,klass)
        if response[:body]["total_entries"].to_i == 0
          return "Zero #{klass} Items Were Found"
        elsif response[:body]["total_entries"].to_i >= 1
          response_for_object                  = {}
          response_for_object[:body]           = build_hash_for_initializer(klass,klass_container(klass),response)
          response_for_object[:response_code]  = response[:response_code]
          response_for_object[:errors]         = response[:errors]
          response_for_object[:server_message] = response[:server_message]

          module_class   = klass.to_s.split(":").last.downcase
          builder_method = "build_for_#{module_class}"
          # Hit the base class method for creating and map collections of objects or maky perhaps another class...
          self.send(builder_method.intern,response_for_object)
        else
          # Raise some type of error
        end
      end


      def handle_pagination(stats)
        
        @total_pages = if stats[:total_entries].to_i == 0
                        0
                      else
                        stats[:total_entries].to_i <= stats[:per_page] ? 1 : (stats[:total_entries].to_f / stats[:per_page].to_f).ceil
                      end
        @current_page  = stats[:current_page]
        @total_entries = stats[:total_entries]
        @per_page      = stats[:per_page]
      end


      private

      def construct_call!(path,path_for_signature)
        if !TicketEvolution.token.nil?
          call                        = Curl::Easy.new(path)
          call.headers["X-Signature"] = sign!(path_for_signature)
          call.headers["X-Token"]     = TicketEvolution.token
          call.headers["Accept"]      = "application/vnd.ticketevolution.api+json; version=8"
          return call
        else
          raise TicketEvolution::InvalidConfiguration.new("You Must Supply A Token To Use The API")
        end
      end
      
      def build_call_path(path,query)
        "#{api_base}/#{path}#{query}"
      end
      
      def sign!(path_for_signature)
        if TicketEvolution.secret
          digest = OpenSSL::Digest::Digest.new('sha256')
          signature = Base64.encode64(OpenSSL::HMAC.digest(digest, TicketEvolution.secret, path_for_signature)).chomp
          return signature
        else
          raise TicketEvolution::InvalidConfiguration.new("You Must Supply A Secret To Use The API")
        end
      end

      # returns array of the processed json, the interperted code and any errors for use
      def handle_response(response)
        begin
          header_response      = response.header_str
          header_response_code = response.response_code
          raw_response         = response.body_str
          body                 = JSON.parse(response.body_str)
          mapped_message       = TicketEvolution::Helpers::Http::Codes[header_response_code].last

          return {:body => body, :response_code => header_response, :server_message => mapped_message , :errors => nil}

        rescue JSON::ParserError
          return { :body=> nil, :response_code => 500, :server_message => "INVALID JSON" }
        end
      end
    end
  end
end
