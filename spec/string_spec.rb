require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")


describe "String" do
  
  it "should take a hash of unalphabetized params and make them alphabetized" do
    params       = {:zone => 'this', :american => 312, :google => 'NYC'}
    expected     = "american=312&google=NYC&zone=this"
    not_expected = "zone=this&american=312&google=NYC"
    Ticketevolution::Base.send(:build_params_for_get,params).should == expected
    Ticketevolution::Base.send(:build_params_for_get,params).should_not == not_expected
  end
  
end
