require 'spec_helper'

describe TicketEvolution::Configuration do
  subject { TicketEvolution::Configuration }

  its(:ancestors) { should include TicketEvolution::Builder }
end
