require 'spec_helper'

describe TicketEvolution::Configurations::Venues do
  let(:klass) { TicketEvolution::Configurations::Venues }
  subject { klass }

  its(:ancestors) { should include TicketEvolution::Venues }
end
