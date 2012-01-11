require File.join(File.dirname(File.expand_path(__FILE__)), "../spec_helper")


describe "Helpers::Catalog" do
  # NB. All of these methods are exnteded into the Ticketevolution Base class meaning they become class methdso
  # other then making a fake module which would not be very accurate testing this the easist and most accurate testing 
  # means
  describe "#klass_to_response_container" do
    it "should return the appropriate stringified version of the class sans the namespaced Ticketevolution" do

      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Performer).should == "performers"
      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Venue).should     == "venues"
      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Category).should  == "categories"  
      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Event).should     == "events"  
      
      # Sanity Negativer Assertions
      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Performer).should_not == "performer"
      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Venue).should_not     == "venue"
      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Category).should_not  == "categorie"  
      TicketEvolution::Base.klass_to_response_container(TicketEvolution::Event).should_not     == "event"
    end
  end
  
  
  describe "#build_hash_for_initializer" do
      
    before(:all) do
      @klass = TicketEvolution::Performer
      @klass_container = "performers"
      @response = {:body=>{"total_entries"=>2, "performers"=>[{"name"=>"Phix Phish Tribute", "category"=>nil, "updated_at"=>"2011-09-27T18:27:16Z", "url"=>"/performers/24504", "id"=>"24504", "venue"=>nil, "upcoming_events"=>{"last"=>nil, "first"=>nil}}, {"name"=>"Phish", "category"=>{"parent"=>{"parent"=>nil, "url"=>"/categories/54", "id"=>"54"}, "url"=>"/categories/82", "id"=>"82"}, "updated_at"=>"2011-12-08T07:14:55Z", "url"=>"/performers/8859", "id"=>"8859", "venue"=>nil, "upcoming_events"=>{"last"=>nil, "first"=>nil}}], "per_page"=>100, "current_page"=>1}, :errors=>nil, :server_message=>"Generally returned by successful GET requests. ", :response_code=>"HTTP/1.1 200 OK\r\nContent-Type: application/vnd.ticketevolution.api+json; version=8; charset=utf-8\r\nTransfer-Encoding: chunked\r\nConnection: keep-alive\r\nStatus: 200\r\nX-Powered-By: Phusion Passenger (mod_rails/mod_rack) 3.0.11\r\nETag: \"1b0778c856cd63e54eb08cd15c790cf8\"\r\nX-UA-Compatible: IE=Edge,chrome=1\r\nX-Runtime: 0.095655\r\nCache-Control: max-age=0, private, must-revalidate\r\nStrict-Transport-Security: max-age=31536000\r\nServer: nginx/1.0.11 + Phusion Passenger 3.0.11 (mod_rails/mod_rack)\r\n\r\n"}
    end
    
    it "should take the hashified response and turn it into a collection of objects to pass off to the class level build to make objects" do
      response = TicketEvolution::Base.build_hash_for_initializer(@klass,@klass_container,@response)
      response.class.should == Array
      response.first.class == TicketEvolution::Performer
    end
  end

end