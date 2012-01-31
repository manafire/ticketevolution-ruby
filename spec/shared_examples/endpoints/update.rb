require 'spec_helper'

shared_examples_for "an update endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

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
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#update can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.update }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe ".included" do
    let(:model_klass) { instance.singular_class }
    let(:model_instance) { model_klass.new(attributes.merge({:connection => connection})) }
    let(:attributes) { HashWithIndifferentAccess.new({:one => 1, :two => "two", :three => nil, :id => 1}) }

    it "should set an update_attributes method on it's corresponding TE:Model class which calls #update" do
      model_instance.should respond_to :update_attributes
      klass.any_instance.should_receive(:update).with(attributes).and_return(nil)
      model_instance.update_attributes(attributes)
    end

    it "should set a save method on it's corresponding assets which calls #update with it's attributes" do
      model_instance.should respond_to :save
      atts = model_instance.attributes
      atts.delete(:id)
      klass.any_instance.should_receive(:update).with(atts).and_return(nil)
      model_instance.save
    end
  end
end
