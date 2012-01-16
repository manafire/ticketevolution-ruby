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
    
    it "return" do
      VCR.use_cassette "category_list_by_parent_it" do
        response = TicketEvolution::Category.list({:parent_id => 1})
        response.first.class.should == TicketEvolution::Category
      end
    end
  end
  
  describe "#show" do
    
  end

  describe "#deleted" do
    
  end
  
end