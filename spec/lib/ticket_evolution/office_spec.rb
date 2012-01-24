require 'spec_helper'

describe TicketEvolution::Office do
  subject { TicketEvolution::Office }

  its(:ancestors) { should include TicketEvolution::Builder }
end
