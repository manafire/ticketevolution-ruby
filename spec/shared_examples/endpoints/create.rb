require 'spec_helper'

shared_examples_for "a create endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:builder_klass) { "TicketEvolution::#{klass.to_s.split('::').last.singularize.camelize}".constantize }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#create" do
    context "with params" do
      let(:params) { {:name => "Bob"} }

      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, nil, instance.endpoint_name.to_sym => [params])

        instance.create(params)
      end
    end

    context "without params" do
      it "should pass call request as a POST, without params" do
        instance.should_receive(:request).with(:POST, nil, nil)

        instance.create
      end
    end
  end

  describe "#build_for_create" do
    let(:response) { Fake.create_response instance.endpoint_name, connection }

    it "should invoke an instance of its builder class" do
      builder_klass.should_receive(:new).with(response.body[instance.endpoint_name].first.merge({
        :status_code => response.response_code,
        :server_message => response.server_message,
        :connection => connection
      }))

      instance.build_for_create(response)
    end
  end
end
