require 'spec_helper'

shared_examples_for "a ticket_evolution endpoint class" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:sample_parent) { TicketEvolution::Samples.new }
  let(:curl) { double(:curl, :http => nil) }
  let(:instance) { klass.new({:parent => connection}) }
  let(:path) { '/search' }
  let(:full_path) { "#{instance.base_path}#{path}" }

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

  describe "#connection" do
    context "the connection object is the parent" do
      subject { klass.new({:parent => connection}) }

      its(:connection) { should == connection }
    end

    context "the connection object is not the parent" do
      subject { klass.new({:parent => TicketEvolution::Endpoint.new({:parent => connection})}) }

      its(:connection) { should == connection }
    end
  end

  describe "#build_request" do

    context "which is valid" do
      context "with params" do
        let(:params) do
          {
            :page => 1,
            :per_page => 10,
            :name => "test"
          }
        end

        [:GET, :POST, :PUT, :DELETE].each do |method|
          it "should accept an http '#{method}' method, a url path for the call and a list of parameters as a hash and pass them to connection" do
            connection.should_receive(:build_request).with(method, full_path, params).and_return(curl)

            instance.build_request(method, path, params)
          end
        end
      end

      context "without params" do
        [:GET, :POST, :PUT, :DELETE].each do |method|
          it "should accept an http '#{method}' method and a url path for the call and pass them to connection" do
            connection.should_receive(:build_request).with(method, full_path, nil).and_return(curl)

            instance.build_request(method, path)
          end
        end
      end
    end

    context "given an invalid http method" do
      it "should raise a EndpointConfigurationError" do
        message = "#{klass.to_s}#request requires it's first parameter to be a valid HTTP method"

        expect { instance.request('BAD', path) }.to raise_error TicketEvolution::EndpointConfigurationError, message
      end
    end
  end

  describe "#request" do
    subject { instance.request method, full_path }
    let(:method) { :GET }
    let(:response) { Fake.response }
    let(:responsible) { :list }

    before do
      instance.instance_eval { @responsible = :list }
      connection.should_receive(:build_request).and_return(curl)
      instance.should_receive(:naturalize_response).and_return(response)
    end

    it "calls http on the return Curl object with the method for the request" do
      instance.should_receive(:build_object).with(responsible, response)
      curl.should_receive(:http).with(method)

      instance.request(method, path)
    end

    context "when there is an error from the api" do
      let(:response) { Fake.error_response }

      before { curl.should_receive(:http) }

      it "should return an instance of TicketEvolution::ApiError" do
        subject.should be_a (TicketEvolution::ApiError)
      end
    end

    context "when successful" do
      let(:response) { Fake.response }

      before { curl.should_receive(:http) }

      it "should pass the response object to #build_object" do
        instance.should_receive(:build_object).with(responsible, response)

        instance.request method, full_path
      end
    end
  end

  describe "#naturalize_response" do
    let(:path) { '/list' }
    let(:instance) { klass.new({:parent => connection}) }
    let(:full_path) { "#{instance.base_path}#{path}" }
    let(:response_code) { 200 }
    let(:response) { mock(:response, {
      :header_str => "header",
      :response_code => response_code,
      :body_str => body_str
    }) }

    context "with a valid body" do
      subject { instance.naturalize_response response }
      let(:body_str) { "{\"test\": \"hello\"}" }

      its(:header) { should == response.header_str }
      its(:body) { should == MultiJson.decode(response.body_str) }

      TicketEvolution::Endpoint::RequestHandler::CODES.each do |code, value|
        context "with response code #{code}" do
          let(:response_code) { code }

          its(:response_code) { should == code }
          its(:server_message) { should == value.last }
        end
      end
    end
  end

  describe "#build_object" do
    let(:instance) { klass.new({:parent => connection}) }
    let(:response) { stub(:response) }

    [:list, :create, :show, :update, :deleted, :search].each do |verb|
      it "should pass response on" do
        method = :"build_for_#{verb}"
        if instance.respond_to? method
          instance.instance_eval "@responsible = :#{verb}"
          instance.should_receive(method).with(response)
          instance.build_object(verb, response)
        end
      end
    end
  end
end
