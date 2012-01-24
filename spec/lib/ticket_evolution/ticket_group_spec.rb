require 'spec_helper'

describe TicketEvolution::TicketGroup do
  subject { TicketEvolution::TicketGroup }

  its(:ancestors) { should include TicketEvolution::Builder }
end
