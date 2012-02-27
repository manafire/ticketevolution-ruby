require 'spec_helper'

shared_examples_for "a search endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#search" do
    context "with params" do
      let(:params) { {:page => 2, :per_page => 2, :q => "test"} }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, '/search', params)

        instance.search(params)
      end
    end

    context "without params" do
      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, '/search', nil)

        instance.search
      end
    end

    context "when passed a block" do
      let(:block) { Fake.response_alt }
      let(:response) { Fake.list_response }

      it "should process the response through the block" do
        instance.should_receive(:naturalize_response).and_return(response)

        instance.search({}, &block).should == block.call(response)
      end
    end
  end

  context "#build_for_search" do
    let(:response) { Fake.list_response }

    it "invokes Collection#build_from_response" do
      TicketEvolution::Collection.
        should_receive(:build_from_response).
        with(response, klass.name.demodulize.underscore, instance.singular_class)
      instance.build_for_search(response)
    end

    it "returns a collection" do
      instance.build_for_search(response).should be_a TicketEvolution::Collection
    end
  end

end
