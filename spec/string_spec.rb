require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")


describe "String" do

  it "should take a hash of unalphabetized params and make them alphabetized and escaped" do
    params       = {:zone => 'this', :american => 312, :google => 'NYC'}
    non_expected_2 = "american=312&google=NYC&zone=this"
    not_expected   = "zone=this&american=312&google=NYC"
    expected       = "american%3D312%26google%3DNYC%26zone%3Dthis"
    response       = TicketEvolution::Base.send(:build_params_for_get,params)
    
    response.should == expected
    response.should_not == not_expected
  end

end
