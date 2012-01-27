require 'spec_helper'

shared_examples_for "a ticket_evolution model" do
  its(:ancestors) { should include TicketEvolution::Model }
end
