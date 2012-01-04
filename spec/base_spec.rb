require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")


describe "Base" do
  describe "#sign" do
    
    it "should raise configuration error when secret is missing" do
      path = "GET api.ticketevolution.com/venues/1"
      Ticketevolution.secret = nil
      # Send needs to be used to circumvent ruby's access rules 
      lambda { Ticketevolution::Base.send(:sign!,path) }.should raise_error(Ticketevolution::InvalidConfiguration)
    end
    
    it "should reutrn back a signature to use for the headers of a request" do
      Ticketevolution.secret = "secure"
      Ticketevolution.token  = "token"
      path                   = "GET api.ticketevolution.com/venues/1?"
 
      digest = OpenSSL::Digest::Digest.new('sha256')
      expected = Base64.encode64(OpenSSL::HMAC.digest(digest, Ticketevolution.secret, path)).chomp
      
      # Send needs to be used to circumvent ruby's access rules 
      signature = Ticketevolution::Base.send(:sign!,path)
      signature.should == (expected)
    end
    
    # ADD TESTING FOR PATH FOR SIGNATURE!!! NEXT
    %w(get post).each do |verb|
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
            
      it "#{verb} call should raise an exception when there is no token setup" do
        Ticketevolution.secret = "secrety-ness"
        Ticketevolution.secret = nil
        path                   = "#{verb.upcase} api.ticketevolution.com/venues/1"
        
        lambda { 
          signature = Ticketevolution::Base.send(:sign!,path) 
          Ticketevolution::Base.send(verb,path)
        }.should raise_error(Ticketevolution::InvalidConfiguration)
      end            
    end
  end
  
  describe "#protocol" do
    it "should return back https when the protocol is initialized with https" do
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
      
      Ticketevolution.send(:protocol).should.eql?("https")
    end
    
    it "should return back http when the protocol is initialized with http" do
        Ticketevolution::configure do |config|
          config.token    = "958acdf7da43b57ac93b17ff26eabf45"
          config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
          config.version  = 8
          config.mode     = :sandbox
          config.protocol = :http
        end

      Ticketevolution.send(:protocol).should.eql?("http")
    end
  
  end
    
  describe "#construct_call" do
    it "should return a call object if all needed parametrs are supplied" do
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end

      path               = "api.ticketevolution.com/perfomers/9?"
      path_for_signature = "GET api.ticketevolution.com/performers/9?"
      
      call = Ticketevolution::Base.send(:construct_call!,path,path_for_signature)
      call.headers["X-Signature"].should.eql?("HtLlrlGmNWMEyRPdSCaRvnW3+YB1WnvMJ6q4/liCr9A=")
      call.headers["Accept"].should.eql?("application/vnd.ticketevolution.api+json; version=8")
      call.headers["X-Secret"].should.eql?(Ticketevolution.secret)
    end
    
    it "raise an exception if the token is not present" do
      lambda {
        Ticketevolution.token = nil
        path               = "api.ticketevolution.com/venues/1"
        path_for_signature = "GET api.ticketevolution.com/venues/1"
        
        Ticketevolution::Base.send(:construct_call!,path,path_for_signature) 
      }.should raise_error(Ticketevolution::InvalidConfiguration)
    end
  end
  
  describe "#environmental_base" do
    it "use the sandbox if configuration of hte client is initialized in sandbox mode" do
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
      
      Ticketevolution::Base.send(:environmental_base).should.eql?("api.sandbox")
    end
    
    it "use production if configuration of hte client is initialized in production mode" do
      Ticketevolution::Base.send(:environmental_base).should.eql?("api")
    end
  end
  
  describe "#http_base" do
    it "should equal the base https and the sandbox" do
      Ticketevolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end
      
      Ticketevolution::Base.send(:http_base).should eql("https://api.sandbox")
      Ticketevolution::Base.send(:http_base).should_not eql("http://sandbox.api")
      Ticketevolution::Base.send(:http_base).should_not eql("http://api")
    end
  end
    
  describe "#build_params_for_get" do
    it "take the hash of parameter and contruct a get friendly set params" do
      params   = {:query => 'this', :venue_id => 312, :location => 'NYC'}
      expected = "location=NYC&query=this&venue_id=312"
      Ticketevolution::Base.send(:build_params_for_get,params).should == expected
    end
    
    it "should take a hash of unalphabetized params and make them alphabetized" do
      params       = {:zone => 'this', :american => 312, :google => 'NYC'}
      expected     = "american=312&google=NYC&zone=this"
      not_expected = "zone=this&american=312&google=NYC"
      Ticketevolution::Base.send(:build_params_for_get,params).should == expected
      Ticketevolution::Base.send(:build_params_for_get,params).should_not == not_expected
    end
  end  
  
  
  describe "#klass_to_response" do
    expected_1 = "venues"
    expected_2 = "categories"
    expected_3 = "performers"
    expected_4 = "events"
    response_1 =  Ticketevolution::Base.send(:klass_to_response, Ticketevolution::Venue)
    response_2 =  Ticketevolution::Base.send(:klass_to_response, Ticketevolution::Category)
    response_3 =  Ticketevolution::Base.send(:klass_to_response, Ticketevolution::Performer)
    response_4 =  Ticketevolution::Base.send(:klass_to_response, Ticketevolution::Event)
    
    response_1.should == expected_1
    response_2.should == expected_2
    response_3.should == expected_3
    response_4.should == expected_4
  end
  

  
  describe "Ticketevolution#handle_pagination" do
    
    it "(singleton) should take the current_page , total_entries , total_pages and currnet_page and store it on any class or base class" do
      stats = {:current_page => 1, :total_entries => 202 , :per_page => 100}
      Ticketevolution::Base.send(:handle_pagination,stats)
      
      Ticketevolution::Base.current_page.should  == 1
      Ticketevolution::Base.total_entries.should == 202
      Ticketevolution::Base.total_pages.should   == 3
      Ticketevolution::Base.per_page.should      == 100
    end
    
    it "(singleton) should round up when the total number is more then the per_page to an integer to cover all results" do
      stats = {:current_page => 1, :total_entries => 1001 , :per_page => 1000}
      Ticketevolution::Base.send(:handle_pagination,stats)
      
      Ticketevolution::Base.current_page.should  == 1
      Ticketevolution::Base.total_entries.should == 1001
      Ticketevolution::Base.total_pages.should   == 2
      Ticketevolution::Base.per_page.should      == 1000
    end
    
    it "(singleton) should take total_entries that divide evenly into per_page and set page to that small number" do
      stats = {:current_page => 1, :total_entries => 50 , :per_page => 100}
      Ticketevolution::Base.send(:handle_pagination,stats)
      
      Ticketevolution::Base.current_page.should  == 1
      Ticketevolution::Base.total_entries.should == 50
      Ticketevolution::Base.total_pages.should   == 1
      Ticketevolution::Base.per_page.should      == 100
    end
  end
  
  describe "#process_response" do
    
  end
   
end