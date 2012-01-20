require 'rubygems'
require 'tempfile'
require 'rspec'
require 'rake'
require 'yaml'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir  = File.join(File.dirname(File.expand_path(__FILE__)), "vcr")
  c.stub_with :webmock
end

RSpec.configure do
  def setup_config
    TicketEvolution::configure do |config|
      config.token    = "958acdf7da43b57ac93b17ff26eabf45"
      config.secret   = "TSalhnVkdoCbGa7I93s3S9OBcBQoogseNeccHIEh"
      config.version  = 8
      config.mode     = :sandbox
    end
  end
end

require File.join(File.dirname(File.expand_path(__FILE__)), "..", "lib", "ticket_evolution")
