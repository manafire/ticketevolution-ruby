require 'spec_helper'

shared_examples_for "a deleted endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#deleted" do
    context "with params" do
      let(:params) { {:page => 2, :per_page => 2} }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, '/deleted', params)

        instance.deleted(params)
      end

      it "should set the @responsible to :deleted so that #request knows how to handle the response" do
        instance.should_receive(:request)
        instance.deleted(params)

        instance.instance_eval("@responsible").should == :deleted
      end
    end

    context "without params" do
      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, '/deleted', nil)

        instance.deleted
      end
    end
  end
end
