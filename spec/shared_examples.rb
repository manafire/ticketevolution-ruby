require 'spec_helper'

shared_examples_for "a ticket_evolution error class" do
  its(:ancestors) { should include Exception }
end

shared_examples_for "a ticket_evolution endpoint class" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:sample_parent) { TicketEvolution::Sample.new }

  describe "#initialize" do
    context "with an options hash for it's first parameter" do
      it "should create accessors for each key value pair" do
        instance = klass.new({
          :parent => connection,
          :test => :one,
          :testing => "two",
          :number => 3,
          :hash => {}
        })
        instance.parent.should == connection
        instance.test.should == :one
        instance.testing.should == "two"
        instance.number.should == 3
        instance.hash.should == {}
      end

      context "with a parent k/v pair" do
        context "that does not inherit from TicketEvolution::Base" do
          it "should raise an EndpointConfigurationError" do
            message = "#{klass} instances require a parent which inherits from TicketEvolution::Base"
            expect {
              klass.new({:parent => Object.new})
            }.to raise_error TicketEvolution::EndpointConfigurationError, message
          end
        end

        context "that does inherit from TicketEvolution::Base" do
          context "and is a TicketEvolution::Connection object" do
            it "should not raise" do
              expect { klass.new({:parent => connection}) }.to_not raise_error
            end
          end

          context "and has a TicketEvolution::Connection object in it's parent chain" do
            let(:sample_chain) do
              TicketEvolution::Endpoint.new({
                :parent => TicketEvolution::Endpoint.new({
                  :parent => connection
                })
              })
            end

            it "should not raise" do
              expect { klass.new({:parent => klass.new({:parent => sample_chain})}) }.to_not raise_error
            end
          end

          context "and does not have a TicketEvolution::Connection object in it's parent chain" do
            it "should raise an EndpointConfigurationError" do
              message = "The parent passed in the options hash must be a TicketEvolution::Connection object or have one in it's parent chain"
              expect {
                klass.new({:parent => sample_parent})
              }.to raise_error TicketEvolution::EndpointConfigurationError, message
            end
          end
        end
      end

      context "without a parent k/v pair" do
        it "should raise an EndpointConfigurationError" do
          message = "The options hash must include a parent key / value pair"
          expect {
            klass.new({})
          }.to raise_error TicketEvolution::EndpointConfigurationError, message
        end
      end
    end

    context "with no first parameter or a non hash object" do
      it "should raise an EndpointConfigurationError" do
        message = "#{klass} instances require a hash as their first parameter"
        expect { klass.new }.to raise_error TicketEvolution::EndpointConfigurationError, message
      end
    end
  end

  describe "#base_path" do
    context "when #parent is a TicketEvolution::Connection object" do
      let(:path) { "/#{klass.to_s.split('::').last.downcase.pluralize}" }

      it "should be generated based on it's class name" do
        klass.new({:parent => connection}).base_path.should == path
      end
    end

    context "when #parent is not a TicketEvolution::Connection object" do
      let(:instance) { klass.new({:parent => connection, :id => 1}) }
      let(:path) { "/#{instance.class.to_s.split('::').last.downcase.pluralize}/#{instance.id}/#{klass.to_s.split('::').last.downcase.pluralize}" }
      it "should be generated based on it's class name and the class names of it's parents" do
        klass.new({:parent => instance}).base_path.should == path
      end
    end
  end
end
