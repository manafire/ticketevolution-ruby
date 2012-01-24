require 'spec_helper'

describe TicketEvolution::Shipment do
  subject { TicketEvolution::Shipment }

  its(:ancestors) { should include TicketEvolution::Builder }
end
