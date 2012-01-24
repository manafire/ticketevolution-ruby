require 'spec_helper'

shared_examples_for "an update endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }

  describe "#update" do
    context "with an id" do
      let(:instance) { klass.new({:parent => connection, :id => 1}) }

      context "with params" do
        let(:params) { {:name => "Bob"} }

        it "should pass call request as a PUT, passing params" do
          instance.should_receive(:request).with(:PUT, "/#{instance.id}", params)

          instance.update(params)
        end
      end

      context "without params" do
        it "should pass call request as a PUT, passing params" do
          instance.should_receive(:request).with(:PUT, "/#{instance.id}", nil)

          instance.update
        end
      end
    end

    context "without an id" do
      let(:instance) { klass.new({:parent => connection}) }

      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#update can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.update }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end
end
