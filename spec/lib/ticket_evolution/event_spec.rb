require 'spec_helper'

describe TicketEvolution::Event do
  subject { TicketEvolution::Event }

  its(:ancestors) { should include TicketEvolution::Builder }
end
