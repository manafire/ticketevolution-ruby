require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")


describe "Base" do
  
  describe "#sign" do
    
    it "should raise configuration error when secret is missing" do
      path = "GET api.ticketevolution.com/venues/1"
      # Send needs to be used to circumvent ruby's access rules 
      lambda { Ticketevolution::Base.send(:sign!,path) }.should raise_error(Ticketevolution::ConfigurationMissing)
    end
    
    it "should reutrn back a signature to use for the headers of a request" do
      Ticketevolution.secret = "secrety-ness"
      path                   = "GET api.ticketevolution.com/venues/1"
      digest = OpenSSL::Digest::Digest.new('sha256')
      expected = Base64.encode64(OpenSSL::HMAC.digest(digest, Ticketevolution.secret, path)).chomp
      
      # Send needs to be used to circumvent ruby's access rules 
      signature = Ticketevolution::Base.send(:sign!,path)
      signature.should.eql?(expected)
    end
    
    
  end
  
end