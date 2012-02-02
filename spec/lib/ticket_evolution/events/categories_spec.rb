require 'spec_helper'

describe TicketEvolution::Events::Categories do
  let(:klass) { TicketEvolution::Events::Categories }
  subject { klass }

  its(:ancestors) { should include TicketEvolution::Categories }
end
