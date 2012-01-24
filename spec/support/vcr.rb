require 'vcr'

VCR.config do |config|
  config.cassette_library_dir = File.join(File.dirname(__FILE__), '..', 'fixtures', 'net')
  config.default_cassette_options = { :record => :none }
  config.ignore_localhost = true
  config.stub_with(:webmock)
end

RSpec.configure do |config|
  config.extend(VCR::RSpec::Macros)
end
