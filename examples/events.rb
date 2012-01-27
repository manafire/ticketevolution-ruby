require 'rubygems'
require 'bundler/setup'
require 'ticket_evolution'

# Run from project root:
# > gem install bundler
# > bundle install
# > ruby examples/events.rb

# Fill these with the credentials for consuming the API
API_TOKEN  = ""
API_SECRET = ""

# Create a client connection to the Ticket Evolution API
client = TicketEvolution::Connection.new(
  :token => API_TOKEN,
  :secret  => API_SECRET
)

# The interface to events can be passed filtering parameters as documented in
# (http://developer.ticketevolution.com/endpoints/events#list).
# For example, pulling 10 events for a particular category
events = client.events.list(:category_id => 24, :per_page => 10)

# Each call to the API endpoint that returns a collection returns a
# TicketEvolution::Collection. This object responds to all Enumerable
# methods (each, collect, etc). It will initialize each object in the
# collection as a TicketEvolution model instance.

event_names = events.collect(&:name)
puts "These are all the events: #{event_names.join(", ")}"

# Our events each get initialized as a TicketEvolution::Event
# object. They will respond to all the attribute values that the event API
# call returned. The model even handles nested associations.
# For example, each event is attached to a venue.

events.each do |event|
  puts "Event '#{event.name}' is at venue '#{event.venue.name}' and occurs at '#{event.occurs_at}'"
end

# If we want to access a single event, and not just query for a collection,
# we can access by ID.

event = client.events.show(events.first.id)
puts "Found a single event: #{event.name}"

# When you run this, you should see something similar to this output. Please
# keep in mind that the events may be different because the events' date may
# have already passed.

# These are all the events: 2012 Ryder Cup Weekly Grounds (Tuesday through Sunday), 2012 Ryder Cup Practice Rounds, 2012 Ryder Cup Practice Rounds, 2012 Ryder Cup Competition Rounds, 2012 Ryder Cup Competition Rounds, 2012 Ryder Cup Competition Rounds, Masters, 2012 Masters - Sunday, 2012 Masters - Monday (Practice Round), 2012 Masters - Friday
# Event '2012 Ryder Cup Weekly Grounds (Tuesday through Sunday)' is at venue 'Medinah Country Club' and occurs at '2012-09-25 08:00:00 UTC'
# Event '2012 Ryder Cup Practice Rounds' is at venue 'Medinah Country Club' and occurs at '2012-09-26 09:00:00 UTC'
# Event '2012 Ryder Cup Practice Rounds' is at venue 'Medinah Country Club' and occurs at '2012-09-27 09:00:00 UTC'
# Event '2012 Ryder Cup Competition Rounds' is at venue 'Medinah Country Club' and occurs at '2012-09-28 09:00:00 UTC'
# Event '2012 Ryder Cup Competition Rounds' is at venue 'Medinah Country Club' and occurs at '2012-09-29 09:00:00 UTC'
# Event '2012 Ryder Cup Competition Rounds' is at venue 'Medinah Country Club' and occurs at '2012-09-30 09:00:00 UTC'
# Event 'Masters' is at venue 'Augusta National Golf Club' and occurs at '2012-04-07 07:00:00 UTC'
# Event '2012 Masters - Sunday' is at venue 'Augusta National Golf Club' and occurs at '2012-04-08 13:00:00 UTC'
# Event '2012 Masters - Monday (Practice Round)' is at venue 'Augusta National Golf Club' and occurs at '2012-04-02 10:00:00 UTC'
# Event '2012 Masters - Friday' is at venue 'Augusta National Golf Club' and occurs at '2012-04-06 13:00:00 UTC'
# Found a single event: 2012 Ryder Cup Weekly Grounds (Tuesday through Sunday)

