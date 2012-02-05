Introduction [![Build Status](https://secure.travis-ci.org/ticketevolution/ticketevolution-ruby.png)](http://travis-ci.org/ticketevolution/ticketevolution-ruby)
============
The Ticket Evolution gem is a toolkit that provides a seamless and total wrapper around the Ticket Evolution APIs. Ticket Evolution uses the gem in-house to build consumer products.

The gem follows an instance based approach to the Restful API. This way multiple credentials can be used within the same environment, avoiding the static nature of ActiveResource. The classes allow you to access all endpoints of the API with a familiar ActiveRecord style -- convenient attribute methods, finders, etc.

All API documentation can be found at [http://developer.ticketevolution.com](http://developer.ticketevolution.com/).

_WARNING: This gem is not ready for prime time. Some of the endpoints have not been added and a few implementation details have yet to be worked out._

**Rubies supported**

- 1.9.2
- 1.8.7
- ree

Installation
============
    # Gemfile
    gem 'ticketevolution-ruby', :require => 'ticket_evolution'

Objects
=======
There are four main object types:

**Connection objects**
Each set of API credentials can be combined with a mode and api version to create a unique connection to Ticket Evolution. A connection object is the basis of any call and must be created before anything else can be done.
_Your API credentials can be found [https://settings.ticketevolution.com/brokerage/credentials](https://settings.ticketevolution.com/brokerage/credentials). You must have an active brokerage account with Ticket Evolution._

There are four available options:
- :token (required)    => The API token, used to identify you
- :secret (required)   => The API secret, used to sign requests (see: [http://developer.ticketevolution.com/signature_tool](http://developer.ticketevolution.com/signature_tool))
- :mode (optional)     => Specifies the server to use - can be either :production or :sandbox (default)
- :version (optional)  => API version to use - the only available version at the time of this writing is 8

    @connection = TicketEvolution::Connection.new({
      :token    => "958acdf7da323bd7a4ac63b17ff26eabf45",
      :secret   => "TSaldkl34kdoCbGa7I93s3S9OBcBQoogseNeccHIEh",
    })

**Endpoint objects**

These are almost always (except in the case of Search) pluralized class names and match the endpoints listed at [http://developer.ticketevolution.com](http://developer.ticketevolution.com/). To instantiate an endpoint instance, create a connection object and then call the endpoints name, underscored, as a method on the connection object.

    @connection.brokerages

Some endpoints are scoped to model objects from other endpoints. One example of this is the Addresses endpoint, which is based off of an instance of TicketEvolution::Client. These endpoints can be called directly off of the model instance.

    @client = @connection.clients.show(1)
    @address = @client.addresses.show(1)

**Model objects**

Calling a create, show or update method will result in the creation of a model object. The type of model object generated matches the endpoint called.

    @connection.brokerages.show(1)    # => an instance of TicketEvolution::Brokerage with an id of 1

**Collection objects**

Calls to list and search methods will return TicketEvolution::Collection objects. These are Enumerable objects containing an array of entries. Each object in this array is an type of model object. In addition to the #entries method, #total_entries, #per_page and #current_page can all be called on collections.

Interacting with an endpoint
============================

    @connection.brokerages.list           # => builds a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage model objects

    @connection.brokerages.show(id)       # => builds a TicketEvolution::Brokerage model object

    @connection.brokerages.search(params) # => returns a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage model objects

Available endpoints
-------------------
Click on the links next to each endpoint for more detail.

**Brokerages** - [http://developer.ticketevolution.com/endpoints/brokerages](http://developer.ticketevolution.com/endpoints/brokerages)

    @brokerage = @connection.brokerages.list(params)
    @brokerage = @connection.brokerages.search(params)
    @brokerage = @connection.brokerages.show(id)

**Offices** - [http://developer.ticketevolution.com/endpoints/offices](http://developer.ticketevolution.com/endpoints/offices)

    @office = @connection.offices.list(params)
    @office = @connection.offices.search(params)
    @office = @connection.offices.show(id)

**Users** - [http://developer.ticketevolution.com/endpoints/users](http://developer.ticketevolution.com/endpoints/users)

    @user = @connection.users.list(params)
    @user = @connection.users.search(params)
    @user = @connection.users.show(id)

**Clients** - [http://developer.ticketevolution.com/endpoints/clients](http://developer.ticketevolution.com/endpoints/clients)

    @client = @connection.clients.create(params)
    @client = @connection.clients.list(params)
    @client = @connection.clients.show(id)
    @client = @client.update(params)

**Addresses** - [http://developer.ticketevolution.com/endpoints/addresses](http://developer.ticketevolution.com/endpoints/addresses)

    @address = @client.addresses.create(params)
    @address = @client.addresses.list(params)
    @address = @client.addresses.show(id)
    @address = @address.update(params)

**Email Addresses** - [http://developer.ticketevolution.com/endpoints/email-addresses](http://developer.ticketevolution.com/endpoints/email-addresses)

    @email_address = @client.email_addresses.create(params)
    @email_address = @client.email_addresses.list(params)
    @email_address = @client.email_addresses.show(id)
    @email_address = @email_address.update(params)

**Phone Numbers** - [http://developer.ticketevolution.com/endpoints/phone-numbers](http://developer.ticketevolution.com/endpoints/phone-numbers)

    @phone_number = @client.phone_numbers.create(params)
    @phone_number = @client.phone_numbers.list(params)
    @phone_number = @client.phone_numbers.show(id)
    @phone_number = @phone_number.update(params)

**Categories** - [http://developer.ticketevolution.com/endpoints/categories](http://developer.ticketevolution.com/endpoints/categories)

    @category = @connection.categories.deleted(params)
    @category = @connection.categories.list(params)
    @category = @connection.categories.show(id)

**Configurations** - [http://developer.ticketevolution.com/endpoints/configurations](http://developer.ticketevolution.com/endpoints/configurations)

    @configuration = @connection.configurations.list(params)
    @configuration = @connection.configurations.show(id)

**Events** - [http://developer.ticketevolution.com/endpoints/events](http://developer.ticketevolution.com/endpoints/events)

    @event = @connection.events.deleted(params)
    @event = @connection.events.list(params)
    @event = @connection.events.show(id)

**Performers** - [http://developer.ticketevolution.com/endpoints/performers](http://developer.ticketevolution.com/endpoints/performers)

    @performer = @connection.performers.deleted(params)
    @performer = @connection.performers.list(params)
    @performer = @connection.performers.search(params)
    @performer = @connection.performers.show(id)

**Search** - [http://developer.ticketevolution.com/endpoints/search](http://developer.ticketevolution.com/endpoints/search)

    @search = @connection.search.list(params)

**Venues** - [http://developer.ticketevolution.com/endpoints/venues](http://developer.ticketevolution.com/endpoints/venues)

    @venue = @connection.venues.deleted(params)
    @venue = @connection.venues.list(params)
    @venue = @connection.venues.search(params)
    @venue = @connection.venues.show(id)

**Ticket Groups** - [http://developer.ticketevolution.com/endpoints/ticket-groups](http://developer.ticketevolution.com/endpoints/ticket-groups)

    @ticket_group = @connection.ticket_groups.list(params)
    @ticket_group = @connection.ticket_groups.show(id)

**Orders** - [http://developer.ticketevolution.com/endpoints/orders](http://developer.ticketevolution.com/endpoints/orders)

    @order = @order.accept(params)
    @order = @order.complete
    @order = @connection.orders.create_brokerage_order(params)
    @order = @connection.orders.create_customer_order(params)
    @order = @connection.orders.create_fulfillment_order(params)
    @order = @connection.orders.list(params)
    @order = @order.reject(params)
    @order = @connection.orders.show(id)
    @order = @order.update(params)

**Quotes** - [http://developer.ticketevolution.com/endpoints/quotes](http://developer.ticketevolution.com/endpoints/quotes)

    @quote = @connection.quotes.list(params)
    @quote = @connection.quotes.search(params)
    @quote = @connection.quotes.show(id)

**Shipments** - [http://developer.ticketevolution.com/endpoints/shipments](http://developer.ticketevolution.com/endpoints/shipments)

    @shipment = @connection.shipments.create(params)
    @shipment = @connection.shipments.list(params)
    @shipment = @connection.shipments.show(id)
    @shipment = @shipment.update(params)

**Accounts** - [http://developer.ticketevolution.com/endpoints/accounts](http://developer.ticketevolution.com/endpoints/accounts)

    @account = @connection.accounts.list(params)
    @account = @connection.accounts.show(id)

**Transactions** - [http://developer.ticketevolution.com/endpoints/transactions](http://developer.ticketevolution.com/endpoints/transactions)

    @transaction = @account.transactions.list(params)
    @transaction = @account.transactions.show(id)

**Credit Cards** - [http://developer.ticketevolution.com/endpoints/credit-cards](http://developer.ticketevolution.com/endpoints/credit-cards)

    @credit_card = @client.credit_cards.create(params)
    @credit_card = @client.credit_cards.list(params)


######ticketevolution-ruby v0.4.9