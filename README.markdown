The Ticketevolution GEM is a toolkit that provides a seamless and total wrapper around the Ticketevolution API's. It provides a Class for each major resource. Any resources that semantically and are actually related (a venue to an event) to others are setup in a manner so that they are associated and related content is accessible within the class itself through delegation and the usuage of proxy apis that are similar to the way thAt Active Record allows for its has_many and belongs_to relationships related objects to be traversed and accessed via Association Proxies. As a connivence all reposes which are returned in the format of JSON are automatically decoded, parsed and instantiated into objects of their respective type

What does this mean in terms of practical terms..... here is an example of how one would interact with the api given the way these tools are setup
First configure and setup your credentials 
> Ticketevolution::configure do |config|
   config.token   = "958acdf7da323bd7a4ac63b17ff26eabf45"
   config.secret  = "TSaldkl34kdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
   config.version = 8
   config.mode    = :sandbox
  end

> venue = Ticketevolution.find(9)
# This makes the call to the API behind the scenes and gives you a local shallow copy of the Venue in question, you can with this access all of the pertinent 
# data and information regarding this Venue, see below
> 


