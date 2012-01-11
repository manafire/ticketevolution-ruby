require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")

describe "Base" do
  describe "#sign" do

    it "should raise configuration error when secret is missing" do
      path = "GET api.TicketEvolution.com/venues/1"
      TicketEvolution.secret = nil
      # Send needs to be used to circumvent ruby's access rules
      lambda { TicketEvolution::Base.send(:sign!,path) }.should raise_error(TicketEvolution::InvalidConfiguration)
    end

    it "should reutrn back a signature to use for the headers of a request" do
      TicketEvolution.secret = "secure"
      TicketEvolution.token  = "token"
      path                   = "GET api.TicketEvolution.com/venues/1?"

      digest = OpenSSL::Digest::Digest.new('sha256')
      expected = Base64.encode64(OpenSSL::HMAC.digest(digest, TicketEvolution.secret, path)).chomp

      # Send needs to be used to circumvent ruby's access rules
      signature = TicketEvolution::Base.send(:sign!,path)
      signature.should == (expected)
    end

    # ADD TESTING FOR PATH FOR SIGNATURE!!! NEXT
    %w(get post).each do |verb|
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end

      it "#{verb} call should raise an exception when there is no token setup" do
        TicketEvolution.secret = "secrety-ness"
        TicketEvolution.token = nil
        path                   = "#{verb.upcase} api.TicketEvolution.com/venues/1"

        lambda {
          signature = TicketEvolution::Base.send(:sign!,path)
          TicketEvolution::Base.send(verb,path)
        }.should raise_error(TicketEvolution::InvalidConfiguration)
      end
    end
  end

  describe "#protocol" do
    it "should return back https when the protocol is initialized with https" do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end

      TicketEvolution.send(:protocol).should.eql?("https")
    end

    it "should return back http when the protocol is initialized with http" do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :http
      end

      TicketEvolution.send(:protocol).should.eql?("http")
    end

  end

  describe "#construct_call" do
    it "should return a call object if all needed parametrs are supplied" do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end

      path               = "api.TicketEvolution.com/perfomers/9?"
      path_for_signature = "GET api.TicketEvolution.com/performers/9?"

      call = TicketEvolution::Base.send(:construct_call!,path,path_for_signature)
      call.headers["X-Signature"].should.eql?("HtLlrlGmNWMEyRPdSCaRvnW3+YB1WnvMJ6q4/liCr9A=")
      call.headers["Accept"].should.eql?("application/vnd.TicketEvolution.api+json; version=8")
      call.headers["X-Secret"].should.eql?(TicketEvolution.secret)
    end

    it "raise an exception if the token is not present" do
      lambda {
        TicketEvolution.token = nil
        path               = "api.TicketEvolution.com/venues/1"
        path_for_signature = "GET api.TicketEvolution.com/venues/1"

        TicketEvolution::Base.send(:construct_call!,path,path_for_signature)
      }.should raise_error(TicketEvolution::InvalidConfiguration)
    end
  end

  describe "#environmental_base" do
    it "use the sandbox if configuration of hte client is initialized in sandbox mode" do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end

      TicketEvolution::Base.send(:environmental_base).should.eql?("api.sandbox")
    end

    it "use production if configuration of hte client is initialized in production mode" do
      TicketEvolution::Base.send(:environmental_base).should.eql?("api")
    end
  end

  describe "#http_base" do
    it "should equal the base https and the sandbox" do
      TicketEvolution::configure do |config|
        config.token    = "958acdf7da43b57ac93b17ff26eabf45"
        config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
        config.version  = 8
        config.mode     = :sandbox
        config.protocol = :https
      end

      TicketEvolution::Base.send(:http_base).should eql("https://api.sandbox")
      TicketEvolution::Base.send(:http_base).should_not eql("http://sandbox.api")
      TicketEvolution::Base.send(:http_base).should_not eql("http://api")
    end
  end

  describe "#build_params_for_get" do
    it "take the hash of parameter and contruct a get friendly set params" do
      params   = {:query => 'this', :venue_id => 312, :location => 'NYC'}
      expected = "location=NYC&query=this&venue_id=312"
      TicketEvolution::Base.send(:build_params_for_get,params).should == expected
    end

    it "should take a hash of unalphabetized params and make them alphabetized" do
      params       = {:zone => 'this', :american => 312, :google => 'NYC'}
      expected     = "american=312&google=NYC&zone=this"
      not_expected = "zone=this&american=312&google=NYC"
      TicketEvolution::Base.send(:build_params_for_get,params).should == expected
      TicketEvolution::Base.send(:build_params_for_get,params).should_not == not_expected
    end
  end


  describe "#klass_to_response_container" do
    expected_1 = "venues"
    expected_2 = "categories"
    expected_3 = "performers"
    expected_4 = "events"
    response_1 =  TicketEvolution::Base.send(:klass_to_response_container, TicketEvolution::Venue)
    response_2 =  TicketEvolution::Base.send(:klass_to_response_container, TicketEvolution::Category)
    response_3 =  TicketEvolution::Base.send(:klass_to_response_container, TicketEvolution::Performer)
    response_4 =  TicketEvolution::Base.send(:klass_to_response_container, TicketEvolution::Event)

    response_1.should == expected_1
    response_2.should == expected_2
    response_3.should == expected_3
    response_4.should == expected_4
  end



  describe "TicketEvolution#handle_pagination" do

    it "(singleton) should take the current_page , total_entries , total_pages and currnet_page and store it on any class or base class" do
      stats = {:current_page => 1, :total_entries => 202 , :per_page => 100}
      TicketEvolution::Base.send(:handle_pagination,stats)

      TicketEvolution::Base.current_page.should  == 1
      TicketEvolution::Base.total_entries.should == 202
      TicketEvolution::Base.total_pages.should   == 3
      TicketEvolution::Base.per_page.should      == 100
    end

    it "(singleton) should round up when the total number is more then the per_page to an integer to cover all results" do
      stats = {:current_page => 1, :total_entries => 1001 , :per_page => 1000}
      TicketEvolution::Base.send(:handle_pagination,stats)

      TicketEvolution::Base.current_page.should  == 1
      TicketEvolution::Base.total_entries.should == 1001
      TicketEvolution::Base.total_pages.should   == 2
      TicketEvolution::Base.per_page.should      == 1000
    end

    it "(singleton) should take total_entries that divide evenly into per_page and set page to that small number" do
      stats = {:current_page => 1, :total_entries => 50 , :per_page => 100}
      TicketEvolution::Base.send(:handle_pagination,stats)

      TicketEvolution::Base.current_page.should  == 1
      TicketEvolution::Base.total_entries.should == 50
      TicketEvolution::Base.total_pages.should   == 1
      TicketEvolution::Base.per_page.should      == 100
    end
  end

  describe "#process_response" do

  end
end
