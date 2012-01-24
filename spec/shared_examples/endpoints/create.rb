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

      it "should set the @responsible to :create so that #request knows how to handle the response" do
        instance.should_receive(:request)
        instance.create(params)

        instance.instance_eval("@responsible").should == :create
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
