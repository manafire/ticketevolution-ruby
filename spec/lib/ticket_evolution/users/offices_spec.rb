require 'spec_helper'

describe TicketEvolution::Users::Offices do
  let(:klass) { TicketEvolution::Users::Offices }
  subject { klass }

  its(:ancestors) { should include TicketEvolution::Offices }
end
