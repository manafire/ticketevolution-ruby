require 'curb'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/string/inflections'
Dir.glob(File.join(File.dirname(__FILE__),".." ,"extensions/*.rb")).sort.each { |f| require f }
Dir.glob(File.join(File.dirname(__FILE__),"..", "lib" ,"ticketevolution","helpers/*.rb")).sort.each { |f| require f }
Dir.glob(File.join(File.dirname(__FILE__),"..", "lib" ,"ticketevolution/*.rb")).sort.each { |f| require f }


# Note the load pattern is important as the helpers need to be instantiated before 
# the acutal classes. The extensions are jsut additions so there will be no missing constants
# but in interest of organization its second

module Ticketevolution
  extend self
  version = "0.1"
  mattr_accessor :token, :secret, :version, :mode, :protocol
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  class InvalidConfiguration < Exception; end
  class EmptyResourceError < Exception;   end

  def configure(&block)
    instance_eval(&block)
  end
  
  # Response Code Mappings From TicketEvolution API
  HTTP_CODE = {
    200 => ["OK","Generally returned by successful GET requests. "],
    201 => ["Created","Generally returned by successful POST requests. "], 
    202 => ["Accepted","Generally returned when a request has succeeded, but has been scheduled processing at a later time. "],
    301 => ["Moved Permanently","Used when a resource's URL has changed."],
    302 => ["Found","Returned when there's a redirect that should be followed."],
    400 => ["Bad Request","Generally returned on POST and PUT requests when validation fails for the given input. "],
    401 => ["Unauthorized","Returned when the authentication credentials are invalid."],
    404 => ["Not Found","The requested resource could not be located."],
    406 => ["Not Acceptable","The requested content type or version is invalid."],
    500 => ["Internal Server Error","Used a general error response for processing errors or other issues with the web service. "],
    503 => ["Service Unavailable","Returned when the API service is temporarily unavailable. This could also indicate that the rate limit for the given token has been reached. If this status is received, the request should be retried."]
  }

end