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
