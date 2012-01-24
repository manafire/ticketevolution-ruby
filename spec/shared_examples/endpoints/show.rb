require 'spec_helper'

shared_examples_for "a show endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:builder_klass) { "TicketEvolution::#{klass.to_s.split('::').last.singularize.camelize}".constantize }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#show" do
    context "with id" do
      let(:id) { 1 }

      it "should pass call request as a GET, passing the id as a piece of the path" do
        instance.should_receive(:request).with(:GET, "/#{id}")

        instance.show(id)
      end

      it "should set the @responsible to :show so that #request knows how to handle the response" do
        instance.should_receive(:request)
        instance.show(id)

        instance.instance_eval("@responsible").should == :show
      end
    end

    context "without id" do
      it "should raise an ArgumentError" do
        expect { instance.show }.to raise_error ArgumentError
      end
    end
  end

  describe "#build_for_show" do
    let(:response) { Fake.show_response }

    before { instance.instance_eval "@responsible = :show" }

    it "should invoke an instance of it's builder class" do
      builder_klass.should_receive(:new).with(response.body.merge({
        :status_code => response.response_code,
        :server_message => response.server_message})
      )

      instance.build_for_show(response)
    end

    it "should unset the @responsible instance variable" do
      instance.build_for_show(response)
      instance.instance_variables.should_not include :@responsible
    end
  end
end
