require 'spec_helper'

describe TicketEvolution::Offices::Brokerages do
  let(:klass) { TicketEvolution::Offices::Brokerages }
  subject { klass }

  its(:ancestors) { should include TicketEvolution::Brokerages }
end
