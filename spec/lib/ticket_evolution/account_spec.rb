require 'spec_helper'

describe TicketEvolution::Account do
  subject { TicketEvolution::Account }

  its(:ancestors) { should include TicketEvolution::Builder }
end
