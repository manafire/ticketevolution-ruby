require 'spec_helper'

shared_examples_for "a ticket_evolution error class" do
  its(:ancestors) { should include Exception }
end

shared_examples_for "a ticket_evolution endpoint class" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:sample_parent) { TicketEvolution::Sample.new }
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

    before do
      connection.should_receive(:build_request).and_return(curl)
      instance.should_receive(:naturalize_response).and_return(response)
    end

    it "calls http on the return Curl object with the method for the request" do
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
end

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
    end

    context "without params" do
      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, nil, nil)

        instance.create
      end
    end

  end
end

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
  end
end

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

  end
end

shared_examples_for "a show endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#show" do
    context "with id" do
      let(:id) { 1 }

      it "should pass call request as a GET, passing the id as a piece of the path" do
        instance.should_receive(:request).with(:GET, "/#{id}")

        instance.show(id)
      end
    end

    context "without id" do
      it "should raise an ArgumentError" do
        expect { instance.show }.to raise_error ArgumentError
      end
    end
  end
end

shared_examples_for "an update endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }

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
      let(:instance) { klass.new({:parent => connection}) }

      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#update can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.update }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end
end
