require "spec_helper"

describe TicketEvolution::Categories do
  use_vcr_cassette "categories", :record => :new_episodes

  let(:connection) { TicketEvolution::Connection.new connection_params }
  let(:categories) { TicketEvolution::Categories.new(connection) }
  let(:connection_params) do
    {
      :token => "958acdf7da43b57ac93b17ff26eabf45",
      :secret => "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh",
      :version => 8,
      :mode => :sandbox
    }
  end

  describe "#list" do
    it "should return categories when a parent_id is passed in" do
      response = categories.list({:parent_id => 1})
      response.first.should be_instance_of TicketEvolution::Category
      response.first.parent_id.should == 1
    end
  end

  describe "#show" do
    it "should return a category object" do
      response = categories.find(2)
      response.should be_instance_of TicketEvolution::Category
      response.name.should  == "Baseball"
    end
  end

  describe "#deleted" do
    pending
  end

  describe "#raw_from_json" do
    pending
  end

  describe "#build_for_category" do
    pending
  end
end
