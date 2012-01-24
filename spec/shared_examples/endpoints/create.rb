require 'spec_helper'

shared_examples_for "a create endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#create" do
    context "with params" do
      let(:params) { {:name => "Bob"} }

      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, nil, params)

        instance.create(params)
      end
    end

    context "without params" do
      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, nil, nil)

        instance.create
      end
    end

  end
end
