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

License
-------

See LICENSE file for licensing information.
