require 'spec_helper'

shared_examples_for "a show endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#show" do
    context "with id" do
      let(:id) { 1 }

      it "should pass call request as a GET, passing the id as a piece of the path" do
        instance.should_receive(:request).with(:GET, "/#{id}")

        instance.show(id)
      end
    end

    context "without id" do
      it "should raise an ArgumentError" do
        expect { instance.show }.to raise_error ArgumentError
      end
    end
  end
end
