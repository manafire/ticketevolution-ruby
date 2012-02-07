Interacting with an endpoint
============================

    @connection.brokerages.list           # => builds a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage model objects

    @connection.brokerages.show(id)       # => builds a TicketEvolution::Brokerage model object

    @connection.brokerages.search(params) # => returns a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage model objects

Alias methods
-------------
To more directly match ActiveRecord style, the following aliases exist and can be called on endpoints which include thier equivalent method:

**#find aliases #show**

    @connection.brokerages.find(1)
    # is the same as calling
    @connection.brokerages.show(1)

**#update_attributes indirectly aliases #update** - A call to #update_attributes will update the attributes on the instance as well as calling #update on the endpoint.

    @brokerage = @connection.brokerages.find(1)
    @brokerage.update_attributes(params)
    # is an easy way to call
    TicketEvolution::Brokerages.new({:connection => @connection, :id => 1}).update(params)

**#save indirectly aliases #update**

    @brokerage = @connection.brokerages.find(1)
    @brokerage.attributes = params
    @brokerage.save
    # is an easy way to call
    TicketEvolution::Brokerages.new({:connection => @connection, :id => 1}).update(params)

**#all aliases #list** - If you use this, be aware that #list maxes out at 100 results, so #all defaultly has the following defined parameter - :limit => 100

    @connection.brokerages.all
    # is the same as calling
    @connection.brokerages.list

Available endpoints
-------------------
Click on the links next to each endpoint for more detail.
