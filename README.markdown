Introduction
============
The Ticketevolution GEM is a toolkit that provides a seamless and total wrapper around the Ticketevolution API's. It provides a Class for each major resource. Any resources that semantically and are actually related (a venue to an event) to others are setup in a manner so that they are associated and related content is accessible within the class itself through delegation and the usage of proxy apis that are similar to the way that Active Record allows for its has_many and belongs_to relationships related objects to be traversed and accessed via Association Proxies.

As a connivence all reposes which are returned in the format of JSON are automatically decoded, parsed and instantiated into objects of their respective type


Installation
------------

    gem install ticketevolution-ruby
    # In your ruby application
    require 'ticket_evolution'

    ### Bundler ###
    # In your Gemfile
    gem 'ticketevolution-ruby'
    # In your Application
    require 'ticket_evolution'


Connecting to Ticketevolution
---------------------

    @connection = TicketEvolution::Connection.new({
      :token    => "958acdf7da323bd7a4ac63b17ff26eabf45",
      :secret   => "TSaldkl34kdoCbGa7I93s3S9OBcBQoogseNeccHIEh",
      :version  => 8,
      :mode     => :sandbox
    })


Interacting with an endpoint (see http://developer.ticketevolution.com for more)
---------------------

    # FORMAT => @connection.<endpoint>.<method>
    #   where endpoint is a Ticket Evolution API endpoint defined at developer.ticketevolution.com

    ### Examples ###

    @connection.brokerages.list           # => builds a TicketEvolution::List object containing
                                          #    a collection of TicketEvolution::Brokerage objects

    @connection.brokerages.show(id)       # => builds a TicketEvolution::Brokerage object (if found)

    @connection.brokerages.search(params) # => returns a TicketEvolution::Search object containing
                                          #    a collection of TicketEvolution::Brokerage objects




LEGACY DOCUMENTATION - REWRITE ME
---------------------

Catalog Resources :: Fetching and Interaction With A Venue
---------------------
    All returned results are cast into Venue objects that have all of their attributes accessible to you. No JSON interaction is needed unless desired
    
    ### Finding And Venue Individually 
    venue = Ticketevolution::Venue.find(9) 
  
    # Using search to find a particular venue (this will return a list a paginated venues that match your query)
    venue = Ticketevolution::Venue.Search("The Stone Pony") 

    venue = Ticketevolution::Venue.find(9)
    venue.name                          # => "Abraham Chavez Theatre"    
    venue.address                       # => { "region"=>"TX", "latitude"=>nil, "country_code"=>"US", "extended_address"=>nil, "postal_code"=>"79901".... }
    venue.location                      # => "El Paso, TX"
    venue.updated_at                    # => "2011-11-28T17:57:00Z"
    venue.url                           # => "/venues/9"
    venue.id                            # => 9
    
    Accessing Associated Other Objects...
    venue.events                        # => [{events}]
    venue.performers                    # => [{performers}]

Catalog Resources :: Fetching and Interaction With A Performer
---------------------
    All returned results are cast into Performer objects that have all of their attributes accessible to you. No JSON interaction is needed unless desired

    ### Finding A Performer Individually 
    person = Ticketevolution::Performer.find(3219) 
  
    # Using search to find a particular venue (this will return a list a paginated venues that match your query)
    person = Ticketevolution::Performer.Search("Dipset") 

    person = Ticketevolution::Performer.find(9)
    person.name                          # => "Dipset"    
    person.category                      # => nil
    person.updated_at                    # => 2011-11-28T17:57:00Z
    person.url                           # => "/performers/3219""
    person.id                            # => 3219
    person.upcoming_events               # => {"last"=>nil, "first"=>nil}
    person.venue                         # => nil
   
    ### Searching For A Performer
    # Using the API when a response returns nothing
    venue = Ticketevolution::Performer.serch("Non-existant")     => In this case the API returns nothing but a friendly message of 
                                                                    "Zero Performers With The Query: Non-Existent Were Found"
    
    # Using the API when a singular response is returned
    venue = Ticketevolution::Performer.serch("Disco Biscuits")   => In this instance the response will instantiated into a Performer object in the same manner
                                                                    as if you had found that performer via its id

    venue = Ticketevolution::Performer.serch("Dave")             => In this case you will get an array of the first 100 Performers that matched and and also a 
                                                                    hash of details concerned the pagination if there are more then 100 with the ability to page
                                                                    to that next set by just calling next.    
    
   
   
Catalog Resources :: Fetching and Interaction With An Event 
---------------------   
All returned results are cast into Performer objects that have all of their attributes accessible to you. No JSON interaction is needed unless desired
    
    ### Finding And Event Individually 
    event = Ticketevolution::Event.find(3219) 

    # Using search to find a particular venue (this will return a list a paginated venues that match your query)
    event = Ticketevolution::Event.Search("3219") 

    event = Ticketevolution::Event.find(9)
    event.name                              # => "Promises Promises"    
    event.category                          # => {"parent"=>nil, "url"=>"/categories/68", "id"=>"68"}
    event.configuration                     
                                            # => "configuration"=>{"name"=>"Full House", "fanvenues_key"=>nil, "url"=>"/configurations/14413", "id"=>"14413",                                                                                               
                                                 "seating_chart"=> {"large"=>"http://media.sandbox.ticketevolution.com/
                                                 configurations/static_maps/14413/large.jpg?1315492230", 
                                                 "medium"=>"http://media.sandbox.ticketevolution.com/configurations/static_maps/14413/medium.jpg?1315492230"}}
    event.id                                # => 3219
    event.name                              # => "/performers/3219""
    event.performances                            # => 3219
    event.products_count                    # => {"last"=>nil, "first"=>nil}
    event.state                             # => nil
    event.updated_at                        # => "2010-11-17T14:52:07Z"
    event.venue                             # => {"name"=>"Broadway Theatre-NY", "location"=>"New York, NY", "url"=>"/venues/187", "id"=>"187"}    
    event.occurs_at                         # => "2010-10-02T14:00:00Z"
    event.url                               # => "/events/3219"
    
    
    Since we have the venue id embedded inside of the venue attribute its as simple as calling event.venue to pull up the full local copy of the venue 
