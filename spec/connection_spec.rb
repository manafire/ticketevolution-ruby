require 'spec_helper'

describe TicketEvolution::Connection do
  let(:connection) { TicketEvolution::Connection.new(connection_params) }
  let(:connection_params) do
    {
      :token => "958acdf7da43b57ac93b17ff26eabf45",
      :secret => "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh",
      :version => 8,
      :mode => :sandbox
    }
  end

  describe "#new" do
    subject { connection }
    context "initializes a connection object" do
      its(:secret) { should == connection_params[:secret] }
      its(:token) { should == connection_params[:token] }
      its(:version) { should == connection_params[:version] }
      its(:mode) { should == connection_params[:mode] }
    end
  end

  describe "#get" do
    it "raises an error if missing a secret" do
      connection = TicketEvolution::Connection.new(connection_params.merge(:secret => nil))

      expect {
        connection.get("/events")
      }.to raise_error(TicketEvolution::InvalidConfiguration)
    end

    it "raises an error if missing a token" do
      connection = TicketEvolution::Connection.new(connection_params.merge(:secret => nil))

      expect {
        connection.get("/events")
      }.to raise_error(TicketEvolution::InvalidConfiguration)
    end

    it "makes a GET request to the URI" do
      VCR.use_cassette("connection/get") do
        path = "events"
        response = connection.get(path)

        expect {
          response[:body].to_json
        }.should_not raise_error

        response[:response_code].should == 200
        response[:errors].should be_nil
      end
    end

    

  end
end
