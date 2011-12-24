require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")


describe "Ticketevolution" do
  
  describe "#configure" do
    
    it "should setup the version and the key and token to use for all calls" do
      Ticketevolution::configure do |config|
        config.token   = "token-to-use"
        config.secret  = "secret-to-use"
        config.version = 8
      end
      
      Ticketevolution.token.should.eql?("token-to-use")
      Ticketevolution.secret.should.eql?("secret-to-use")
      Ticketevolution.version.should.eql?(8)
    end
    
  end
  
end