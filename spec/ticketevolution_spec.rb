require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")


describe "TicketEvolution" do
  
  describe "#configure" do
    
    it "should setup the version and the key and token to use for all calls" do
      TicketEvolution::configure do |config|
        config.token   = "token-to-use"
        config.secret  = "secret-to-use"
        config.version = 8
        config.mode    = :sandbox
      end
      
      TicketEvolution.token.should.eql?("token-to-use")
      TicketEvolution.secret.should.eql?("secret-to-use")
      TicketEvolution.version.should.eql?(8)
      TicketEvolution.mode.should.eql?(:sandbox)
    end
    
  end
  
end