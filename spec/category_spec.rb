require "spec_helper"

describe "TicketEvolution::Category" do

  describe "#list" do
    before(:all) do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
      end
    end
    
    it "should return categories when a parent_id is passed in" do
      VCR.use_cassette "category_list_by_parent_it" do
        response = TicketEvolution::Category.list({:parent_id => 1})
        response.first.class.should == TicketEvolution::Category
      end
    end
  end
  
  describe "#show" do
    before(:all) do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
      end
    end
    
    it "should return a category object" do
      VCR.use_cassette "category/find_call" do
        response = TicketEvolution::Category.find(2)
        response.class.should == TicketEvolution::Category
        response.name.should  == "Baseball" 
      end
    end
  end

  describe "#deleted" do
    
  end
  
end