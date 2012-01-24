require 'spec_helper'

describe TicketEvolution::Quote do
  subject { TicketEvolution::Quote }

  its(:ancestors) { should include TicketEvolution::Builder }
end
