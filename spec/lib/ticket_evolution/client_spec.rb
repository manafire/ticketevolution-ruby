require 'spec_helper'

describe TicketEvolution::Client do
  subject { TicketEvolution::Client }

  its(:ancestors) { should include TicketEvolution::Builder }
end
