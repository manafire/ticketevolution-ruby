require 'spec_helper'

describe TicketEvolution::Events::Venues do
  let(:klass) { TicketEvolution::Events::Venues }
  subject { klass }

  its(:ancestors) { should include TicketEvolution::Venues }
end
