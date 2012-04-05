require 'spec_helper'

describe TicketEvolution::Shipment do
  subject { TicketEvolution::Shipment }

  it_behaves_like "a ticket_evolution model"

  context "custom methods" do
    let(:connection) { Fake.connection }
    let(:instance) { TicketEvolution::Shipment.new({:connection => connection, 'id' => 1}) }
    let(:plural_klass) { TicketEvolution::Shipments}
    let!(:plural_klass_instance) { plural_klass.new(:parent => connection) }

    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => 1).and_return(plural_klass_instance)
    end

    describe "#generate_airbill" do
      it "should pass the request to TicketEvolution::Orders#accept_order" do
        plural_klass_instance.should_receive(:generate_airbill).and_return(:dont_care)

        instance.generate_airbill
      end
    end
  end
end
