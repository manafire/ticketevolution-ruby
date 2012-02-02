Introduction
============
The Ticket Evolution gem is a toolkit that provides a seamless and total wrapper around the Ticket Evolution APIs. Ticket Evolution uses the gem in-house to build consumer products.

The gem follows an instance based approach to the Restful API. This way multiple credentials can be used within the same environment, avoiding the static nature of ActiveResource. The classes allow you to access all endpoints of the API with a familiar ActiveRecord style -- convenient attribute methods, finders, etc.

All API documentation can be found at [http://developer.ticketevolution.com](http://developer.ticketevolution.com/).

[![Build Status](https://secure.travis-ci.org/ticketevolution/ticketevolution-ruby.png)](http://travis-ci.org/ticketevolution/ticketevolution-ruby)

_WARNING: This gem is not ready for prime time. Some of the endpoints have not been added and a few implementation details have yet to be worked out._

**Rubies supported**

- 1.9.2

**Soon to be supported**

- 1.8.7
- ree


Installation
------------
    # Gemfile
    gem 'ticketevolution-ruby', :require => "ticket_evolution", :git => "git://github.com/ticketevolution/ticketevolution-ruby.git"


Connecting to Ticket Evolution
------------------------------
Your API credentials can be found [https://settings.ticketevolution.com/brokerage/credentials](https://settings.ticketevolution.com/brokerage/credentials). You must have an active brokerage account with Ticket Evolution.

    @connection = TicketEvolution::Connection.new({
      :token    => "958acdf7da323bd7a4ac63b17ff26eabf45",
      :secret   => "TSaldkl34kdoCbGa7I93s3S9OBcBQoogseNeccHIEh",
    })


Interacting with an endpoint
----------------------------

    ### Examples ###

    @connection.brokerages.list           # => builds a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage objects

    @connection.brokerages.show(id)       # => builds a TicketEvolution::Brokerage object (if found)

    @connection.brokerages.search(params) # => returns a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage objects

Examples
--------
Please see the examples folder for usage of the API. It will require the credentials found at [https://settings.ticketevolution.com/brokerage/credentials](https://settings.ticketevolution.com/brokerage/credentials).

License
-------

See LICENSE file for licensing information.
