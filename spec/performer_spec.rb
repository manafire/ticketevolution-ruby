# require File.join(File.dirname(File.expand_path(__FILE__)), "spec_helper")
# 
# describe "Ticketevolution::Perfomer" do
# 
#   
#   describe "#find" do
#     Ticketevolution::configure do |config|
#       config.token    = "958acdf7da43b57ac93b17ff26eabf45"
#       config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
#       config.version  = 8
#       config.mode     = :sandbox
#       config.protocol = :https
#     end
#     performer = Ticketevolution::Performer.find(3219)
#     
#     performer.inspect
#     
# 
#   end
#   
#   describe "#show" do
#     
#   end
#   
#   after(:each) do
#     Ticketevolution.token    = nil
#     Ticketevolution.secret   = nil
#     Ticketevolution.version  = nil
#     Ticketevolution.mode     = nil
#     Ticketevolution.protocol = nil
#   end
# end