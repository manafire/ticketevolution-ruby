module Ticketevolution
  module Helpers
    module Http
      
      # Response Code Mappings From TicketEvolution API
      Codes = {            
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
  end
end