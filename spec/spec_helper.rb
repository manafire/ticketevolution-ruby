require 'rubygems'
require 'tempfile'
require 'rspec'
require 'rake'
require 'vcr'

# VCR.config do |c|
#   c.cassette_library_dir = 'spec/vcr_cassettes'
#   c.hook :webmock
#   c.configure_rspec_metadata!
# end

RSpec.configure do |c|
  # so we can use `:vcr` rather than `:vcr => true`;
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true
end



require File.join(File.dirname(File.expand_path(__FILE__)), "..", "lib", "ticketevolution")

