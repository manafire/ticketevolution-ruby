require 'spec_helper'

describe TicketEvolution::Events::Configurations do
  let(:klass) { TicketEvolution::Events::Configurations }
  subject { klass }

  its(:ancestors) { should include TicketEvolution::Configurations }
end
