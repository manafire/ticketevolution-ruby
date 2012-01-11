TicketEvolution::configure do |config|
  config.token    = "958acdf7da43b57ac93b17ff26eabf45"
  config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
  config.version  = 8
  config.mode     = :sandbox
  config.protocol = :https

end


phish = TicketEvolution::Performer.search("Phish")