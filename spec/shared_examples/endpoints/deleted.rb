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
    end

    context "without params" do
      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, '/deleted', nil)

        instance.deleted
      end
    end

    context "when passed a block" do
      let(:block) { Fake.response_alt }
      let(:response) { Fake.list_response }

      it "should process the response through the block" do
        instance.should_receive(:naturalize_response).and_return(response)

        instance.deleted({}, &block).should == block.call(response)
      end
    end
  end

  context "#build_for_deleted" do
    let(:response) { Fake.list_response }

    it "invokes Collection#build_from_response" do
      TicketEvolution::Collection.
        should_receive(:build_from_response).
        with(response, klass.name.demodulize.underscore, instance.singular_class)
      instance.build_for_deleted(response)
    end

    it "returns a collection" do
      instance.build_for_deleted(response).should be_a TicketEvolution::Collection
    end
  end
end
