require 'spec_helper'

describe TicketEvolution::Category do
  subject { TicketEvolution::Category }

  its(:ancestors) { should include TicketEvolution::Builder }
end
