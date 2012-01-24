require 'spec_helper'

shared_examples_for "a list endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#list" do
    context "with params" do
      let(:params) { {:page => 2, :per_page => 2} }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, nil, params)

        instance.list(params)
      end
    end

    context "without params" do
      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, nil, nil)

        instance.list
      end
    end
  end
end
