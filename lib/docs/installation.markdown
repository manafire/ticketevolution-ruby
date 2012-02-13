Installation
============

Rails / Bundler
---------------
In your Gemfile, add the following line

    gem 'ticketevolution-ruby', :require => 'ticket_evolution'

Ruby / IRB
----------
In bash / terminal

    gem install ticketevolution-ruby
    irb

Then

    require 'rubygems'
    require 'ticket_evolution'
    @connection = TicketEvolution::Connection.new({
      :token => '<YOUR TOKEN>',
      :secret => '<YOUR SECRET>'
    })
    @connection.brokerages.list({:per_page => 1})

