require 'spec_helper'

describe TicketEvolution::User do
  subject { TicketEvolution::User }

  its(:ancestors) { should include TicketEvolution::Builder }
end
