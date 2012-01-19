require File.join(File.dirname(File.expand_path(__FILE__)), "../spec_helper")


describe "Helpers::Base" do
  
  describe "#build_params_for_get" do
    it "should take in a list of parameters and alphabetaize them" do
      parameters   = {:name => "david", :parent_id => "321", :updated_at => "TIME", :bs => "YES", :inerted_params => "dsds"}
      not_expected = CGI.escape("inerted_params=dsds&bs=YES&name=david&parent_id=321&updated_at=TIME") 
      
      expected   = CGI.escape("bs=YES&inerted_params=dsds&name=david&parent_id=321&updated_at=TIME")  
      organized_parameters_escaped_parameters = TicketEvolution::Base.build_params_for_get(parameters)
      organized_parameters_escaped_parameters.should     == expected
      organized_parameters_escaped_parameters.should_not == not_expected
    end
    
    it "should work with integers by casting them to strings" do
      expected     = "bs%3D21%26name%3D21%26parent_id%3D321%26updated_at%3D12"  
      parameters   = {:name => 21, :parent_id => 321, :updated_at => 12, :bs => 21}
      
      organized_parameters_escaped_parameters = TicketEvolution::Base.build_params_for_get(parameters)
      expected.should == "bs%3D21%26name%3D21%26parent_id%3D321%26updated_at%3D12"
    end
  end
  
  
  describe "#sanitize_parameters" do
    # Rspec should include willl ONLY take strings. Bummer so the maps and the keys are really symbols be 
    # converted for rspec's sake [DKM 2012.01.15]
    params_hash = {:name => "david", :nefarious => "haackers"}
    response = TicketEvolution::Base.sanitize_parameters(TicketEvolution::Category,:deleted, params_hash)
    response.keys.include?(:name).should == true
    response.values.include?("david").should == true
    response.keys.include?("nefarious").should == false
    response.values.include?("haackers") == false
    
    params_hash = {:name => "david", :parent_id => "321", :updated_at => "TIME", :bs => "YES", :inerted_params => "dsds"}
    response = TicketEvolution::Base.sanitize_parameters(TicketEvolution::Category,:deleted, params_hash)
    response.keys.include?(:updated_at).should == true
    response.keys.include?(:name).should == true
    response.keys.include?(:parent_id).should == true
     
    response.values.include?("TIME").should == true
    response.values.include?("david").should == true
    response.values.include?("321").should == true

    response.keys.include?(:bs).should == false
    response.keys.include?(:inerted_params).should == false
  end
  
  describe "#clean_and_remove" do
    white_list  = %w(name age birth)
    params_hash = {:name => "david", :nefarious => "haackers"}
    response = TicketEvolution::Base.clean_and_remove(white_list, params_hash)
    response.keys.include?(:name).should == true
    
    
    white_list  = %w(name age birth)
    params_hash = {:name => "david", :age => "21"}
    response = TicketEvolution::Base.clean_and_remove(white_list, params_hash)
    response.keys.include?(:age).should == true
    response.keys.include?(:name).should == true
    
    white_list  = %w(name age birth)
    params_hash = {:bs => "david", :bad => "haackers"}
    response = TicketEvolution::Base.clean_and_remove(white_list, params_hash)
    response.keys.should == []
  end

end
